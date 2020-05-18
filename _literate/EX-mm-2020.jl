# **Main author**: [Stefan Wojcik](https://github.com/stefanjwojcik)
# **Original repo**: [mm2020](https://github.com/stefanjwojcik/mm2020)

# ## Getting started

# This script creates features and a ML modeling for predicting the outcome of the Men's NCAA March Madness Tournament. You will need to load the data from Kaggle, find that [here](https://www.kaggle.com/c/march-madness-analytics-2020).
#
# First, load some dependencies. The primary machine learning methods are done using the [MLJ](https://github.com/alan-turing-institute/MLJ.jl).

using MLJ, Test, Pipe, Random
using CSVFiles, DataFrames

MLJ.color_off() # hide
Random.seed!(1212)

# Get the submission sample which will be used to create the features for the final submission.

mm20 = joinpath("_data", "mm20")
sample = joinpath(mm20, "MSampleSubmissionStage1_2020.csv")
submission_sample = CSVFiles.load(sample) |> DataFrame


# Load all the source data required to generate basic features: the seeds, the compact season data, the detailed season data, and the seasonal tournament data.

 df_seeds = CSVFiles.load("data/MDataFiles_Stage1/MNCAATourneySeeds.csv") |> DataFrame
 season_df = CSVFiles.load("data/MDataFiles_Stage1/MRegularSeasonCompactResults.csv") |> DataFrame
 season_df_detail = CSVFiles.load("data/MDataFiles_Stage1/MRegularSeasonDetailedResults.csv") |> DataFrame
 tourney_df  = CSVFiles.load("data/MDataFiles_Stage1/MNCAATourneyCompactResults.csv") |> DataFrame
```

Finally, due to some compatibility issues with MixedModels.jl, load team effects, which had to be generated and saved in a separate environment. I'll describe how these were created a bit later, but you can recreate them yourself with the code [teameffects.jl](https://github.com/stefanjwojcik/mm2020/blob/master/src/teameffects.jl).

 ```julia
 ranefs = CSVFiles.load("data/raneffects.csv") |> DataFrame
```

### Load Seed Training Features

The differences in seed ranking for every team in the tournament.

```julia
seeds_features = make_seeds(copy(df_seeds), copy(tourney_df))
```

### Load Efficiency Training Features

Team efficiency scores, an advanced feature engineering exercise, ported from [this](https://www.kaggle.com/lnatml/feature-engineering-with-advanced-stats) Python notebook. Basically they measure how efficiently a team capitalizes on possessions.

```julia
Wfdat, Lfdat, effdat = eff_stat_seasonal_means(copy(season_df_detail))
eff_features = get_eff_tourney_diffs(Wfdat, Lfdat, effdat, copy(tourney_df))
```

### Load ELO Training Features

Generate ELO ranks from the data. This required creating a mutable struct that possesses all the features required to calculate the ELO rank, then running an ELO function on the struct.

```julia
season_elos = elo_ranks(Elo())
elo_features = get_elo_tourney_diffs(season_elos, copy(tourney_df))
```

### Momentum

Generate scores capturing momentum late in the season. The code below uses the last two weeks of the season data to get the median team score differences in this set of games.

```julia
momentum_features, momentum_df = make_momentum(copy(tourney_df), copy(season_df))
```

Finally, this code **would** generate team effects by season - team differences from the baseline probability of winning using a Mixed Effects model from the [MixedModels.jl](https://github.com/JuliaStats/MixedModels.jl) package. This package is essentially a port of the 'lmer' package in R.

### Team Effects
```julia
ranef_features = make_ranef_features(copy(tourney_df), ranefs)
```

### Filtering and joining

Most features don't go back very far, so 2003 is the earliest possible complete dataset available. The code below uses the 'filter' functionality in [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) to reduce the data to what is available.

```julia
seeds_features_min = filter(row -> row[:Season] >= 2003, seeds_features)
eff_features_min = filter(row -> row[:Season] >= 2003, eff_features)
elo_features_min = filter(row -> row[:Season] >= 2003, elo_features)
momentum_features_min = filter(row -> row[:Season] >= 2003, momentum_features)
ranef_features_min = filter(row -> row[:Season] >= 2003, ranef_features)
```

Join all the data to one dataframe for training, and delete the ID columns that cannot be used for training.

```julia
stub = join(seeds_features_min, eff_features_min, on = [:WTeamID, :LTeamID, :Season, :Result], kind = :left);

fdata = join(stub, elo_features, on = [:WTeamID, :LTeamID, :Season, :Result], kind = :left);

fdata = join(fdata, momentum_features_min, on = [:WTeamID, :LTeamID, :Season, :Result], kind = :left);

fdata = join(fdata, ranef_features_min, on = [:WTeamID, :LTeamID, :Season, :Result], kind = :left);

exclude = [:Result, :Season, :LTeamID, :WTeamID]
deletecols!(fdata, exclude)
```

Now create the same features for the submission file:

```julia
# Create features required to make submission predictions
seed_submission = get_seed_submission_diffs(copy(submission_sample), df_seeds)
eff_submission = get_eff_submission_diffs(copy(submission_sample), effdat) #see above
elo_submission = get_elo_submission_diffs(copy(submission_sample), season_elos)
momentum_submission = make_momentum_sub(copy(submission_sample), momentum_df)
ranef_submission = make_ranef_sub(copy(submission_sample), ranefs)

# Create full submission dataset
submission_features = hcat(seed_submission, eff_submission, elo_submission, momentum_submission, ranef_submission)

```

 Join all the features into a complete DataFrame which we will split into train, test, and submission. The training data will be used to train and tune the model, the testing data will be used to verify the accuracy metrics of the final model.

```julia
featurecols = [names(seed_submission), names(eff_submission), names(elo_submission), names(momentum_submission), names(ranef_submission)]
featurecols = collect(Iterators.flatten(featurecols))
fullX = [fdata[featurecols]; submission_features[featurecols]]
fullY = [seeds_features_min.Result; repeat([0], size(submission_features, 1))]
```

The base dataset that we can use for training and testing is 2230 rows, so we will use MLJ and the partition function to identify the rows we will use for training and testing. We also pipe the outcome variable to win and loss as certain models will expect that structure. We also need to coerce the features dataframe to continuous.

```julia
train, test = partition(1:2230, 0.7, shuffle=true)
validate = [2231:size(fullY, 1)...]
y = @pipe categorical(fullY.y) |> recode(_, 0=>"lose",1=>"win");
fullX_co = coerce(fullX, Count=>Continuous)
```

Now, let's load the XGBoost Classifier from the MLJ package.

```julia
@load XGBoostClassifier()
xgb = XGBoostClassifier()
```

MLJ has a lot of features for tuning hyperparameters of a model. I won't go into examples, there are many on tutorials on the [MLJ](https://alan-turing-institute.github.io/MLJTutorials/) tutorials site. I highly recommend it.

```julia
xgb.num_round = 4
xgb.max_depth = 3
xgb.min_child_weight = 4.2105263157894735
xgb.gamma = 11
xgb.eta = .35
xgb.subsample = 0.6142857142857143
xgb.colsample_bytree = 1.0
```

```julia
xgb_forest = EnsembleModel(atom=xgb, n=1000);
#xgb_forest.bagging_fraction = .8
xg_model = machine(xgb_forest, fullX_co, y)
fit!(xg_model, rows = train)
yhat = predict(xg_model, rows=test)
```

Now, let's evaluate it's performance! First, let's look at the results on the training set, even though we cannot rely on this to generalize.

```julia
accuracy(predict_mode(xg_model, rows=train), y[train])
```

That is not bad performance. In prior NCAA tournaments, I've found it's often hard to make it to 70% accuracy on the tournament. Let's see if it holds on the testing set, a more accurate representation of performance of the model.

```julia
mce = cross_entropy(yhat, y[train]) |> mean

accuracy(predict_mode(xg_model, rows=test), y[test])
```

Woot! Not bad! There you go, a machine learning model with Julia. Not that hard. And there are so many ways you can optimize julia to be even faster. There is a great book by [Avik Sengupta](https://www.amazon.com/Julia-High-performance-Avik-Sengupta/dp/1785880918#ace-g0160871354) detailing how to do this.
