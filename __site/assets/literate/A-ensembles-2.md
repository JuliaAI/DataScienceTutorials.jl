<!--This file was generated, do not modify it.-->
## Prelims

This tutorial builds upon the previous ensemble tutorial with a home-made Random Forest regressor on the "boston" dataset.

```julia:ex1
using MLJ, PyPlot, PrettyPrinting, Random,
      DataFrames

X, y = @load_boston
sch = schema(X)
p = length(sch.names)
n = sch.nrows
@show (n, p)
describe(y)
```

Let's load the decision tree regressor

```julia:ex2
@load DecisionTreeRegressor
```

Let's first check the performances of just a single Decision Tree Regressor (DTR for short):

```julia:ex3
tree = machine(DecisionTreeRegressor(), X, y)
e = evaluate!(tree, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e |> pprint
```

Note that multiple measures can be reported simultaneously.

## Random forest

Let's create an ensemble of DTR and fix the number of subfeatures to 3 for now.

```julia:ex4
forest = EnsembleModel(atom=DecisionTreeRegressor())
forest.atom.n_subfeatures = 3
```

(**NB**: we could have fixed `n_subfeatures` in the DTR constructor too).

To get an idea of how many trees are needed, we can follow the evaluation of the error (say the `rms`) for an increasing number of tree over several sampling round.

```julia:ex5
Random.seed!(5) # for reproducibility
m = machine(forest, X, y)
r = range(forest, :n, lower=10, upper=1000)
curves = learning_curve!(m, resampling=Holdout(fraction_train=0.8),
                         range=r, measure=rms, n=4);
```

let's plot the curves

```julia:ex6
figure(figsize=(8,6))
plot(curves.parameter_values, curves.measurements)
xlabel("Number of trees", fontsize=14)
xticks([10, 250, 500, 750, 1000])
ylim([4, 5])

savefig("assets/literate/A-ensembles-2-curves.svg")
```

![RMS vs number of trees](/assets/literate/A-ensembles-2-curves.svg)

So out of this curve we could decide for instance to go for 300 trees:

```julia:ex7
forest.n = 300;
```

### Tuning

As `forest` is a composite model, it has nested hyperparameters:

```julia:ex8
params(forest) |> pprint
```

Let's define a range for the number of subfeatures and for the bagging fraction:

```julia:ex9
r_sf = range(forest, :(atom.n_subfeatures), lower=1, upper=12)
r_bf = range(forest, :bagging_fraction, lower=0.4, upper=1.0);
```

And build a tuned model as usual that we fit on a 80/20 split.
We use a low-resolution grid here to make this tutorial faster but you could of course use a finer grid.

```julia:ex10
tuned_forest = TunedModel(model=forest,
                          tuning=Grid(resolution=3),
                          resampling=CV(nfolds=6, rng=32),
                          ranges=[r_sf, r_bf],
                          measure=rms)
m = machine(tuned_forest, X, y)
e = evaluate!(m, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e |> pprint
```

### Reporting
Again, you could show a 2D heatmap of the hyperparameters

```julia:ex11
r = report(m)

figure(figsize=(8,6))

vals_sf = r.parameter_values[:, 1]
vals_bf = r.parameter_values[:, 2]

tricontourf(vals_sf, vals_bf, r.measurements)
xticks(1:3:12, fontsize=12)
xlabel("Number of sub-features", fontsize=14)
yticks(0.4:0.2:1, fontsize=12)
ylabel("Bagging fraction", fontsize=14)

savefig("assets/literate/A-ensembles-2-heatmap.svg") # hide
```

![](/assets/literate/A-ensembles-2-heatmap.svg)

Even though we've only done a very rough search, it seems that around 7 sub-features and a bagging fraction of around `0.75` work well.

Now that the machine `m` is trained, you can use use it for predictions (implicitly, this will use the best model).
For instance we could look at predictions on the whole dataset:

```julia:ex12
ŷ = predict(m, X)
rms(ŷ, y)
```

