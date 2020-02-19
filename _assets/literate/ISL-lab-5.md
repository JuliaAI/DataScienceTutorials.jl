<!--This file was generated, do not modify it.-->
## Getting started

```julia:ex1
using MLJ, RDatasets

auto = dataset("ISLR", "Auto")
y, X = unpack(auto, ==(:MPG), col->true)
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=444);
```

Note the use of `rng=` to seed the shuffling of indices so that the results are reproducible.

### Polynomial regression

```julia:ex2
@load LinearRegressor pkg=MLJLinearModels
```

In this part we only build models with the `Horsepower` feature.

```julia:ex3
using PyPlot

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig("assets/literate/ISL-lab-5-g1.svg") # hide
```

![MPG v Horsepower](/assets/literate/ISL-lab-5-g1.svg)

Let's get a baseline:

```julia:ex4
lm = LinearRegressor()
mlm = machine(lm, select(X, :Horsepower), y)
fit!(mlm, rows=train)
rms(predict(mlm, rows=test), y[test])^2
```

Note that we square the measure to  match the results obtained in the ISL labs where the mean squared error (here we use the `rms` which is the square root of that).

```julia:ex5
xx = (Horsepower=range(50, 225, length=100) |> collect, )
yy = predict(mlm, xx)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy, lw=3)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig("assets/literate/ISL-lab-5-g2.svg") # hide
```

![1st order baseline](/assets/literate/ISL-lab-5-g2.svg)

We now want to build three polynomial models of degree 1, 2 and 3 respectively; we start by forming the corresponding feature matrix:

```julia:ex6
hp = X.Horsepower
Xhp = DataFrame(hp1=hp, hp2=hp.^2, hp3=hp.^3);
```

Now we  can write a simple pipeline where the first step selects the features we want (and with it the degree of the polynomial) and the second is the linear regressor:

```julia:ex7
@pipeline LinMod(fs = FeatureSelector(features=[:hp1]),
                 lr = LinearRegressor());
```

Then we can  instantiate and fit 3 models where we specify the features each time:

```julia:ex8
lrm = LinMod()
lr1 = machine(lrm, Xhp, y) # poly of degree 1 (line)
fit!(lr1, rows=train)

lrm.fs.features = [:hp1, :hp2] # poly of degree 2
lr2 = machine(lrm, Xhp, y)
fit!(lr2, rows=train)

lrm.fs.features = [:hp1, :hp2, :hp3] # poly of degree 3
lr3 = machine(lrm, Xhp, y)
fit!(lr3, rows=train)
```

Let's check the performances on the test set

```julia:ex9
get_mse(lr) = rms(predict(lr, rows=test), y[test])^2

@show get_mse(lr1)
@show get_mse(lr2)
@show get_mse(lr3)
```

Let's visualise the models

```julia:ex10
hpn  = xx.Horsepower
Xnew = DataFrame(hp1=hpn, hp2=hpn.^2, hp3=hpn.^3)

yy1 = predict(lr1, Xnew)
yy2 = predict(lr2, Xnew)
yy3 = predict(lr3, Xnew)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy1, lw=3, label="Order 1")
plot(xx.Horsepower, yy2, lw=3, label="Order 2")
plot(xx.Horsepower, yy3, lw=3, label="Order 3")

legend(fontsize=14)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig("assets/literate/ISL-lab-5-g3.svg") # hide
```

![1st, 2nd and 3d order fit](/assets/literate/ISL-lab-5-g3.svg)

## K-Folds Cross Validation

Let's crossvalidate over the degree of the  polynomial.

**Note**: there's a  bit of gymnastics here because MLJ doesn't directly support a polynomial regression; see our tutorial on [tuning models](/pub/getting-started/model-tuning.html) for a gentler introduction to model tuning.
The gist of the following code is to create a dataframe where each column is a power of the `Horsepower` feature from 1 to 10 and we build a series of regression models using incrementally more of those features (higher degree):

```julia:ex11
Xhp = DataFrame([hp.^i for i in 1:10])

cases = [[Symbol("x$j") for j in 1:i] for i in 1:10]
r = range(lrm, :(fs.features), values=cases)

tm = TunedModel(model=lrm, ranges=r, resampling=CV(nfolds=10), measure=rms)
```

Now we're left with fitting the tuned model

```julia:ex12
mtm = machine(tm, Xhp, y)
fit!(mtm)
rep = report(mtm)
@show round.(rep.measurements.^2, digits=2)
@show argmin(rep.measurements)
```

So the conclusion here is that the 5th order polynomial does quite well.

In ISL they use a different seed so the results are a bit different but comparable.

```julia:ex13
Xnew = DataFrame([hpn.^i for i in 1:10])
yy5 = predict(mtm, Xnew)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy5, lw=3)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig("assets/literate/ISL-lab-5-g4.svg") # hide
```

![5th order fit](/assets/literate/ISL-lab-5-g4.svg)

## The Bootstrap

_Bootstrapping is not currently supported in MLJ._

