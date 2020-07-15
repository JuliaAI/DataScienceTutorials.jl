# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Prelims## This tutorial builds upon the previous ensemble tutorial with a home-made Random Forest regressor on the "boston" dataset.
using MLJ
using PyPlot
using PrettyPrinting
using StableRNGs
import DataFrames



X, y = @load_boston
sch = schema(X)
p = length(sch.names)
n = sch.nrows
@show (n, p)
DataFrames.describe(y)

# Let's load the decision tree regressor
@load DecisionTreeRegressor

# Let's first check the performances of just a single Decision Tree Regressor (DTR for short):
tree = machine(DecisionTreeRegressor(), X, y)
e = evaluate!(tree, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e |> pprint # use PrettyPrinting

# Note that multiple measures can be reported simultaneously.
# ## Random forest## Let's create an ensemble of DTR and fix the number of subfeatures to 3 for now.
forest = EnsembleModel(atom=DecisionTreeRegressor())
forest.atom.n_subfeatures = 3

# (**NB**: we could have fixed `n_subfeatures` in the DTR constructor too).## To get an idea of how many trees are needed, we can follow the evaluation of the error (say the `rms`) for an increasing number of tree over several sampling round.
rng = StableRNG(5123) # for reproducibility
m = machine(forest, X, y)
r = range(forest, :n, lower=10, upper=1000)
curves = learning_curve!(m, resampling=Holdout(fraction_train=0.8, rng=rng),
                         range=r, measure=rms);

# let's plot the curves
figure(figsize=(8,6))
plot(curves.parameter_values, curves.measurements)
ylabel("Root Mean Squared error", fontsize=16)
xlabel("Number of trees", fontsize=16)
xticks([10, 250, 500, 750, 1000], fontsize=14)
yticks(fontsize=14)



# \figalt{RMS vs number of trees}{A-ensembles-2-curves.svg}## The curve is pretty noisy but let's just go for 150 trees:
forest.n = 150;

# ### Tuning## As `forest` is a composite model, it has nested hyperparameters:
params(forest) |> pprint

# Let's define a range for the number of subfeatures and for the bagging fraction:
r_sf = range(forest, :(atom.n_subfeatures), lower=1, upper=12)
r_bf = range(forest, :bagging_fraction, lower=0.4, upper=1.0);

# And build a tuned model as usual that we fit on a 80/20 split.# We use a low-resolution grid here to make this tutorial faster but you could of course use a finer grid.
tuned_forest = TunedModel(model=forest,
                          tuning=Grid(resolution=3),
                          resampling=CV(nfolds=6, rng=StableRNG(32)),
                          ranges=[r_sf, r_bf],
                          measure=rms)
m = machine(tuned_forest, X, y)
e = evaluate!(m, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e |> pprint

# ### Reporting# Again, you could show a 2D heatmap of the hyperparameters
r = report(m)

figure(figsize=(8,6))

res = r.plotting

vals_sf = res.parameter_values[:, 1]
vals_bf = res.parameter_values[:, 2]

tricontourf(vals_sf, vals_bf, res.measurements)
xticks(1:3:12, fontsize=12)
xlabel("Number of sub-features", fontsize=14)
yticks(0.4:0.2:1, fontsize=12)
ylabel("Bagging fraction", fontsize=14)



# \fig{A-ensembles-2-heatmap.svg}## Even though we've only done a very rough search, it seems that around 7 sub-features and a bagging fraction of around `0.75` work well.## Now that the machine `m` is trained, you can use use it for predictions (implicitly, this will use the best model).# For instance we could look at predictions on the whole dataset:
ŷ = predict(m, X)
rms(ŷ, y)



# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

