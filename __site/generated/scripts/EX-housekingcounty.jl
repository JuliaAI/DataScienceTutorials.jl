# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Getting started## This tutorial is adapted from [the corresponding MLR3 tutorial](https://mlr3gallery.mlr-org.com/posts/2020-01-30-house-prices-in-king-county/).## ### Loading and  preparing the data
using MLJ
using PrettyPrinting
import DataFrames: DataFrame, select!, Not, describe
import Statistics
using Dates
using PyPlot

using UrlDownload



df = DataFrame(urldownload("https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data/kc_housing.csv", true))
describe(df)

# We drop unrelated columns
select!(df, Not([:id, :date]))
schema(df)

# Afterwards, we convert the zip code to an unordered factor (`Multiclass`), we also create two binary features `isrenovated` and `has_basement` derived from `yr_renovated` and `sqft_basement`:
coerce!(df, :zipcode => Multiclass)
df.isrenovated  = @. !iszero(df.yr_renovated)
df.has_basement = @. !iszero(df.sqft_basement)
schema(df)

# These created variables should be treated as OrderedFactor,
coerce!(df, :isrenovated => OrderedFactor, :has_basement => OrderedFactor);

# The feature `waterfront` is currently encoded as a string, but it's really just a boolean:
unique(df.waterfront)

# So let's recode it
df.waterfront = (df.waterfront .!= "FALSE")
coerce!(df, :waterfront => OrderedFactor);

# For a number of the remaining features which are treated as `Count` there are few unique values in which case it might make more sense to recode them as OrderedFactor, this can be done with `autotype`:
coerce!(df, autotype(df, :few_to_finite))
schema(df)

# Let's also rescale the column `price` to be in 1000s of dollars:
df.price = df.price ./ 1000;

# For simplicity let's just drop a few additional columns that don't seem to matter much:
select!(df, Not([:yr_renovated, :sqft_basement, :zipcode]));

# ### Basic data visualisation## Let's plot a basic histogram of the prices to get an idea for the distribution:
plt.figure(figsize=(8,6))
plt.hist(df.price, color = "blue", edgecolor = "white", bins=50,
         density=true, alpha=0.5)
plt.xlabel("Price", fontsize=14)
plt.ylabel("Frequency", fontsize=14)


# \figalt{Histogram of the prices}{hist_price.svg}
# Let's see if there's a difference between renovated and unrenovated flats:
plt.figure(figsize=(8,6))
plt.hist(df.price[df.isrenovated .== true], color="blue", density=true,
        edgecolor="white", bins=50, label="renovated", alpha=0.5)
plt.hist(df.price[df.isrenovated .== false], color="red", density=true,
        edgecolor="white", bins=50, label="unrenovated", alpha=0.5)
plt.xlabel("Price", fontsize=14)
plt.ylabel("Frequency", fontsize=14)
plt.legend(fontsize=12)


# \figalt{Histogram of the prices depending on renovation}{hist_price2.svg}# We can observe that renovated flats seem to achieve higher sales values, and this might thus be a relevant feature.### Likewise, this could be done to verify that `condition`, `waterfront` etc are important features.
# ## Fitting a first model
@load DecisionTreeRegressor

y, X = unpack(df, ==(:price), col -> true)
train, test = partition(eachindex(y), 0.7, shuffle=true, rng=5)

tree = machine(DecisionTreeRegressor(), X, y)

fit!(tree, rows=train);

# Let's see how it does
rms(y[test], predict(tree, rows=test))

# Let's try to do better.
# ### Random forest model
# We might be able to improve upon the RMSE using more powerful learners.
@load RandomForestRegressor pkg=ScikitLearn

# That model only accepts input in the form of `Count` and so we have to coerce all `Finite` types into `Count`:
coerce!(X, Finite => Count);

# Now we can fit
rf_mdl = RandomForestRegressor()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

rms(y[test], predict(rf, rows=test))

# A bit better but it would be best to check this a bit more carefully:
cv3 = CV(; nfolds=3)
res = evaluate(rf_mdl, X, y, resampling=CV(shuffle=true),
               measure=rms, verbosity=0)

# ### GBM## Let's try a different kind of model: Gradient Boosted Decision Trees from the package xgboost and we'll try to tune it too.
@load XGBoostRegressor

# It expects a `Table(Continuous)` input so we need to coerce `X` again:
coerce!(X, Count => Continuous)

xgb  = XGBoostRegressor()
xgbm = machine(xgb, X, y)
fit!(xgbm, rows=train)

rms(y[test], predict(xgbm, rows=test))

# Let's try to tune it, first we define ranges for a number of useful parameters:
r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :num_round, lower=1, upper=25);

# And now we tune, we use a very coarse resolution because we use so many ranges, `2^7` is already some 128 models...
tm = TunedModel(model=xgb, tuning=Grid(resolution=7),
                resampling=CV(rng=11), ranges=[r1,r2],
                measure=rms)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)

rms(y[test], predict(mtm, rows=test))

# Tuning helps a fair bit!


# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

