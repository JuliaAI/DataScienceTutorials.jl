<!--This file was generated, do not modify it.-->
````julia:ex1
using Pkg # hideall
Pkg.activate("_literate/end-to-end/boston-lgbm/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;
````

**Main author**: Yaqub Alwan (IQVIA).

@@dropdown
## Getting started
@@
@@dropdown-content

````julia:ex2
using MLJ
import DataFrames
import Statistics
import StableRNGs.StableRNG

MLJ.color_off() # hide
LGBMRegressor = @load LGBMRegressor pkg=LightGBM
````

Let us try LightGBM out by doing a regression task on the Boston house prices dataset.
This is a commonly used dataset so there is a loader built into MLJ.

Here, the objective is to show how LightGBM can do better than a Linear Regressor
with minimal effort.

We start out by taking a quick peek at the data itself and its statistical properties.

````julia:ex3
features, targets = @load_boston
features = DataFrames.DataFrame(features);
@show size(features)
@show targets[1:3]
first(features, 3)
````

````julia:ex4
schema(features)
````

We can also describe the dataframe

````julia:ex5
DataFrames.describe(features)
````

Do the usual train/test partitioning. This is important so we can estimate
generalisation.

````julia:ex6
train, test = partition(eachindex(targets), 0.70, rng=StableRNG(52))
````

Let us investigate some of the commonly tweaked LightGBM parameters. We start with
looking at a learning curve for number of boostings.

````julia:ex7
lgb = LGBMRegressor() #initialised a model with default params
mach = machine(lgb, features[train, :], targets[train, 1])
curve = learning_curve(
    mach,
    resampling=CV(nfolds=5),
    range=range(lgb, :num_iterations, lower=2, upper=500),
    resolution=60,
    measure=rms,
)

using Plots
dims = (600, 370)
plt = plot(curve.parameter_values, curve.measurements, size=dims)
xlabel!("Number of rounds", fontsize=14)
ylabel!("RMSE", fontsize=14)

savefig(joinpath(@OUTPUT, "lgbm_hp1.svg")); # hide
````

\fig{lgbm_hp1.svg}

It looks like that we don't need to go much past 100 boosts

Since LightGBM is a gradient based learning method, we also have a learning rate
parameter which controls the size of gradient updates.

Let us look at a learning curve for this parameter too

````julia:ex8
lgb = LGBMRegressor() #initialised a model with default params
mach = machine(lgb, features[train, :], targets[train, 1])

curve = learning_curve(
    mach,
    resampling=CV(nfolds=5),
    range=range(lgb, :learning_rate, lower=1e-3, upper=1, scale=:log),
    resolution=60,
    measure=rms,
)

plot(
    curve.parameter_values,
    curve.measurements,
    size=dims,
    xscale =:log10,
)
xlabel!("Learning rate (log scale)", fontsize=14)
ylabel!("RMSE", fontsize=14)

savefig(joinpath(@OUTPUT, "lgbm_hp2.svg")); # hide
````

\fig{lgbm_hp2.svg}

It seems like near 0.5 is a reasonable place. Bearing in mind that for lower values of
learning rate we possibly require more boosting in order to converge, so the default
value of 100 might not be sufficient for convergence. We leave this as an exercise to
the reader.  We can still try to tune this parameter, however.

Finally let us check number of datapoints required to produce a leaf in an individual
tree. This parameter controls the complexity of individual learner trees, and too low a
value might lead to overfitting.

````julia:ex9
lgb = LGBMRegressor() #initialised a model with default params
mach = machine(lgb, features[train, :], targets[train, 1])
````

dataset is small enough and the lower and upper sets the tree to have certain number of
leaves

````julia:ex10
curve = learning_curve(
    mach,
    resampling=CV(nfolds=5),
    range=range(lgb, :min_data_in_leaf, lower=1, upper=50),
    measure=rms,
)

plot(curve.parameter_values, curve.measurements, size=dims)
xlabel!("Min data in leaf", fontsize=14)
ylabel!("RMSE", fontsize=14)

savefig(joinpath(@OUTPUT, "lgbm_hp3.svg")); # hide
````

\fig{lgbm_hp3.svg}

It does not seem like there is a huge risk for overfitting, and lower is better for this
parameter.

Using the learning curves above we can select some small-ish ranges to jointly search
for the best combinations of these parameters via cross validation.

````julia:ex11
r1 = range(lgb, :num_iterations, lower=50, upper=100)
r2 = range(lgb, :min_data_in_leaf, lower=2, upper=10)
r3 = range(lgb, :learning_rate, lower=1e-1, upper=1e0)
tuned_model = TunedModel(
    lgb,
    tuning=RandomSearch(),
    resampling=CV(rng=StableRNG(123)),
    ranges=[r1,r2,r3],
    measure=rms,
    n=100,
)
mach = machine(tuned_model, features, targets)
fit!(mach, rows=train);
````

Let's see what the cross validation best model parameters turned out to be?

````julia:ex12
best_model = fitted_params(mach).best_model
@show best_model.learning_rate
@show best_model.min_data_in_leaf
@show best_model.num_iterations
````

Great, and now let's predict using the held out data (predicting using the `TunedModel`
machine uses the best model trained on all the `train` data):

````julia:ex13
predictions = MLJ.predict(mach, rows=test)
rms_score = round(rms(predictions, targets[test, 1]), sigdigits=4)

@show rms_score
````

‎
@@

