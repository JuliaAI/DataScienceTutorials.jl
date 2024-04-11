<!--This file was generated, do not modify it.-->
````julia:ex1
using Pkg # hideall
Pkg.activate("_literate/A-ensembles-2/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;
````

@@dropdown
## Prelims
@@
@@dropdown-content

This tutorial builds upon the previous ensemble tutorial with a home-made Random Forest regressor on the "boston" dataset.

````julia:ex2
using MLJ
using PrettyPrinting
using StableRNGs
import DataFrames: DataFrame, describe
MLJ.color_off() # hide

X, y = @load_boston
sch = schema(X)
p = length(sch.names)
describe(y)  # From DataFrames
````

Let's load the decision tree regressor

````julia:ex3
DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree
````

Let's first check the performances of just a single Decision Tree Regressor (DTR for short):

````julia:ex4
tree = machine(DecisionTreeRegressor(), X, y)
e = evaluate!(tree, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e
````

Note that multiple measures can be reported simultaneously.

‎
@@
@@dropdown
## Random forest
@@
@@dropdown-content

Let's create an ensemble of DTR and fix the number of subfeatures to 3 for now.

````julia:ex5
forest = EnsembleModel(model=DecisionTreeRegressor())
forest.model.n_subfeatures = 3
````

(**NB**: we could have fixed `n_subfeatures` in the DTR constructor too).

To get an idea of how many trees are needed, we can follow the evaluation of the error (say the `rms`) for an increasing number of tree over several sampling round.

````julia:ex6
rng = StableRNG(5123) # for reproducibility
m = machine(forest, X, y)
r = range(forest, :n, lower=10, upper=1000)
curves = learning_curve(m, resampling=Holdout(fraction_train=0.8, rng=rng),
                         range=r, measure=rms);
````

let's plot the curves

````julia:ex7
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.2) # hide

plot(curves.parameter_values, curves.measurements,
xticks = [10, 100, 250, 500, 750, 1000],
size=(800,600), linewidth=2, legend=false)
xlabel!("Number of trees")
ylabel!("Root Mean Squared error")

savefig(joinpath(@OUTPUT, "A-ensembles-2-curves.svg")); # hide
````

\figalt{RMS vs number of trees}{A-ensembles-2-curves.svg}

Let's go for 150 trees

````julia:ex8
forest.n = 150;
````

@@dropdown
### Tuning
@@
@@dropdown-content

As `forest` is a composite model, it has nested hyperparameters:

````julia:ex9
params(forest) |> pprint
````

Let's define a range for the number of subfeatures and for the bagging fraction:

````julia:ex10
r_sf = range(forest, :(model.n_subfeatures), lower=1, upper=12)
r_bf = range(forest, :bagging_fraction, lower=0.4, upper=1.0);
````

And build a tuned model as usual that we fit on a 80/20 split.
We use a low-resolution grid here to make this tutorial faster but you could of course use a finer grid.

````julia:ex11
tuned_forest = TunedModel(model=forest,
                          tuning=Grid(resolution=3),
                          resampling=CV(nfolds=6, rng=StableRNG(32)),
                          ranges=[r_sf, r_bf],
                          measure=rms)
m = machine(tuned_forest, X, y)
e = evaluate!(m, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e
````

‎
@@
@@dropdown
### Reporting
@@
@@dropdown-content
Again, we can visualize the results from the hyperparameter search

````julia:ex12
plot(m)

savefig(joinpath(@OUTPUT, "A-ensembles-2-heatmap.svg")); # hide
````

\fig{A-ensembles-2-heatmap.svg}

Even though we've only done a very rough search, it seems that around 7 sub-features and a bagging fraction of around `0.75` work well.

Now that the machine `m` is trained, you can use use it for predictions (implicitly, this will use the best model).
For instance we could look at predictions on the whole dataset:

````julia:ex13
ŷ = predict(m, X)
@show rms(ŷ, y)
````

‎
@@

‎
@@

