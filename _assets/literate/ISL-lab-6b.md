<!--This file was generated, do not modify it.-->
## Getting started

```julia:ex1
using MLJ, RDatasets, ScientificTypes, PrettyPrinting
import Distributions
const D = Distributions

@load LinearRegressor pkg=MLJLinearModels
@load RidgeRegressor pkg=MLJLinearModels
@load LassoRegressor pkg=MLJLinearModels

hitters = dataset("ISLR", "Hitters")
@show size(hitters)
names(hitters) |> pprint
```

The target is `Salary`

```julia:ex2
y, X = unpack(hitters, ==(:Salary), col->true);
```

It has missing values which we will just ignore:

```julia:ex3
no_miss = .!ismissing.(y)
y = collect(skipmissing(y))
X = X[no_miss, :]
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=424);
```

```julia:ex4
using PyPlot

figure(figsize=(8,6))
plot(y, ls="none", marker="o")

xticks(fontsize=12); yticks(fontsize=12)
xlabel("Index", fontsize=14), ylabel("Salary", fontsize=14)

savefig("assets/literate/ISL-lab-6-g1.svg") # hide
```

![Salary](/assets/literate/ISL-lab-6-g1.svg)

That looks quite skewed, let's have a look at a histogram:

```julia:ex5
figure(figsize=(8,6))
hist(y, bins=50, density=true)

xticks(fontsize=12); yticks(fontsize=12)
xlabel("Salary", fontsize=14); ylabel("Density", fontsize=14)

edfit = D.fit_mle(D.Exponential, y)
xx = range(minimum(y), 2500, length=100)
yy = pdf.(edfit, xx)
plot(xx, yy, lw=3, label="Exponential distribution fit")

legend(fontsize=12)

savefig("assets/literate/ISL-lab-6-g2.svg") # hide
```

![Distribution of salary](/assets/literate/ISL-lab-6-g2.svg)

### Data preparation

Most features are currently encoded as integers but we will consider them as continuous

```julia:ex6
Xc = coerce(X, autotype(X, rules=(:discrete_to_continuous,)))
scitype(Xc)
```

There're a few features that are categorical which we'll one-hot-encode.

## Ridge pipeline
### Baseline

Let's first fit a simple pipeline with a standardizer, a one-hot-encoder and a basic linear regression:

```julia:ex7
@pipeline RegPipe(std = Standardizer(),
                  hot = OneHotEncoder(),
                  reg = LinearRegressor())

model = RegPipe()
pipe  = machine(model, Xc, y)
fit!(pipe, rows=train)
ŷ = predict(pipe, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)
```

Let's get a feel for how we're doing

```julia:ex8
figure(figsize=(8,6))

res = ŷ .- y[test]
stem(res)

xticks(fontsize=12); yticks(fontsize=12)
xlabel("Index", fontsize=14); ylabel("Residual (ŷ - y)", fontsize=14)

ylim([-1300, 1000])

savefig("assets/literate/ISL-lab-6-g3.svg") # hide
```

![Residuals](/assets/literate/ISL-lab-6-g3.svg)

```julia:ex9
figure(figsize=(8,6))
hist(res, bins=30, density=true, color="green")

xx = range(-1100, 1100, length=100)
ndfit = D.fit_mle(D.Normal, res)
lfit  = D.fit_mle(D.Laplace, res)

plot(xx, pdf.(ndfit, xx), lw=3, color="orange", label="Normal fit")
plot(xx, pdf.(lfit, xx), lw=3, color="magenta", label="Laplace fit")

legend(fontsize=12)

xticks(fontsize=12); yticks(fontsize=12)
xlabel("Residual (ŷ - y)", fontsize=14); ylabel("Density", fontsize=14)
xlim([-1100, 1100])

savefig("assets/literate/ISL-lab-6-g4.svg") # hide
```

![Distribution of residuals](/assets/literate/ISL-lab-6-g4.svg)

### Basic Ridge

Let's now swap the linear regressor for a Ridge one without specifying the penalty (`1` by default):

```julia:ex10
pipe.model.reg = RidgeRegressor()
fit!(pipe, rows=train)
ŷ = predict(pipe, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)
```

Ok that's a bit better but surely we can do better with an appropriate selection of the hyperparameter.

### Cross validating

What penalty should you use? Let's do a simple CV to try  to find out:

```julia:ex11
r  = range(model, :(reg.lambda), lower=1e-2, upper=100_000, scale=:log10)
tm = TunedModel(model=model, ranges=r, tuning=Grid(resolution=50),
                resampling=CV(nfolds=3, rng=4141), measure=rms)
mtm = machine(tm, Xc, y)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.reg.lambda, sigdigits=4)
```

right, and  with that we get:

```julia:ex12
ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)
```

Let's see:

```julia:ex13
figure(figsize=(8,6))

res = ŷ .- y[test]
stem(res)

xticks(fontsize=12); yticks(fontsize=12)
xlabel("Index", fontsize=14); ylabel("Residual (ŷ - y)", fontsize=14)

ylim([-1300, 1000])

savefig("assets/literate/ISL-lab-6-g5.svg") # hide
```

![Ridge residuals](/assets/literate/ISL-lab-6-g5.svg)

You can compare that with the residuals obtained earlier.

## Lasso pipeline

Let's do the same as above but using a Lasso model and adjusting the range a bit:

```julia:ex14
mtm.model.model.reg = LassoRegressor()
mtm.model.ranges = range(model, :(reg.lambda), lower=500, upper=100_000, scale=:log10)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.reg.lambda, sigdigits=4)
```

Ok and let's see how that does:

```julia:ex15
ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)
```

Pretty good! and the parameters are reasonably sparse as expected:

```julia:ex16
coefs, intercept = fitted_params(mtm.fitresult.fitresult.machine)
round.(coefs, sigdigits=2)
```

with around 50% sparsity:

```julia:ex17
sum(coefs .≈ 0) / length(coefs)
```

Let's visualise this:

```julia:ex18
figure(figsize=(8,6))
stem(coefs)

# name of the features including one-hot-encoded ones
all_names = [:AtBat, :Hits, :HmRun, :Runs, :RBI, :Walks, :Years,
             :CAtBat, :CHits, :CHmRun, :CRuns, :CRBI, :CWalks,
             :League__A, :League__N, :Div_E, :Div_W,
             :PutOuts, :Assists, :Errors, :NewLeague_A, :NewLeague_N]

idxshow = collect(1:length(coefs))[abs.(coefs) .> 10]
xticks(idxshow .- 1, all_names[idxshow], rotation=45, fontsize=12)
yticks(fontsize=12)
ylabel("Amplitude", fontsize=14)

savefig("assets/literate/ISL-lab-6-g6.svg") # hide
```

![Lasso coefficients](/assets/literate/ISL-lab-6-g6.svg)

## Elastic net pipeline

```julia:ex19
@load ElasticNetRegressor pkg=MLJLinearModels

mtm.model.model.reg = ElasticNetRegressor()
mtm.model.ranges = [range(model, :(reg.lambda), lower=0.1, upper=100, scale=:log10),
                    range(model, :(reg.gamma),  lower=500, upper=10_000, scale=:log10)]
mtm.model.tuning = Grid(resolution=10)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
@show round(best_mdl.reg.lambda, sigdigits=4)
@show round(best_mdl.reg.gamma, sigdigits=4)
```

And it's not too bad in terms of accuracy either

```julia:ex20
ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)
```

But the simple ridge regression seems to work best here.

