<!--This file was generated, do not modify it.-->
## Simple linear regression

`MLJ` essentially serves as a unified path to many existing Julia packages each of which provides their own functionalities and models, with their own conventions.

The simple linear regression demonstrates this.
Several packages offer it (beyond just using the backslash operator): here we will use `MLJLinearModels` but we could also have used `GLM`, `ScikitLearn` etc.

To load the model from a given package use `@load ModelName pkg=PackageName`

```julia:ex1
using MLJ

@load LinearRegressor pkg=MLJLinearModels
```

Note: in order to be able to load this, you **must** have the relevant package in your environment, if you don't, you can always add it (``using Pkg; Pkg.add("MLJLinearModels")``).

Let's load the _boston_ data set

```julia:ex2
using RDatasets, DataFrames
boston = dataset("MASS", "Boston")
first(boston, 3)
```

Let's get a feel for the data

```julia:ex3
describe(boston, :mean, :std, :eltype)
```

So there's no missing value and most variables are floating point.
In MLJ it's important to specify the interpretation of the features (should it be considered as a Continuous feature, as a Count, ...?), see [this tutorial section](/pub/getting-started/choosing-a-model.html#data_and_its_interpretation) on scientific types.

Here we will just interpret the integer features as continuous as we will just use a basic linear regression; the `ScientificTypes` package helps us with that:

```julia:ex4
using ScientificTypes
data = coerce(boston, autotype(boston, :discrete_to_continuous));
```

Let's also extract the target variable (`MedV`):

```julia:ex5
y = data.MedV
X = select(data, Not(:MedV));
```

Let's declare a simple multivariate linear regression model:

```julia:ex6
mdl = LinearRegressor()
```

In order to fit it on the data, we need to wrap it in a _machine_ which, in MLJ, is the composition of a model and data to apply the model on:

```julia:ex7
mach = machine(mdl, X, y)
fit!(mach)
```

The `fit!` operation trains the model on the data and the results are kept inside of the machine.
In this case we have trained it on the whole data.
You can retrieve the fitted parameters using `fitted_params`:

```julia:ex8
fp = fitted_params(mach)
@show round.(fp.coefs[1:3], sigdigits=3)
@show round(fp.intercept, sigdigits=3)
```

You can use the `machine` in order to _predict_ values as well and, for instance, compute the root mean squared error:

```julia:ex9
ŷ = predict(mach, X)
round(rms(ŷ, y), sigdigits=4)
```

Let's see what the residuals look like

```julia:ex10
using PyPlot

figure(figsize=(8,6))
res = ŷ .- y
stem(res)

savefig("assets/literate/ISL-lab-3-res.svg") # hide
```

![](/assets/literate/ISL-lab-3-res.svg)

Maybe that a histogram is more appropriate here

```julia:ex11
figure(figsize=(8,6))
hist(res, density=true)
x = range(-20, 20, )

savefig("assets/literate/ISL-lab-3-res2.svg") # hide
```

![](/assets/literate/ISL-lab-3-res2.svg)

## Interaction and transformation

Let's say we want to also consider an interaction term of `lstat` and `age` taken together.
To do this, just create a new dataframe with an additional column corresponding to the interaction term:

```julia:ex12
X2 = hcat(X, X.LStat .* X.Age);
```

So here we have a DataFrame with one extra column corresponding to the elementwise products between `:LStat` and `Age`.
DataFrame gives this a default name (`:x1`) which we can change:

```julia:ex13
rename!(X2, :x1 => :interaction);
```

Ok cool, now let's try the linear regression again

```julia:ex14
mach = machine(mdl, X2, y)
fit!(mach)
ŷ = predict(mach, X2)
round(rms(ŷ, y), sigdigits=4)
```

We get slightly better results but nothing spectacular.

Let's get back to the lab where they consider regressing the target variable on `lstat` and `lstat^2`; again, it's essentially a case of defining the right DataFrame:

```julia:ex15
X3 = hcat(X.LStat, X.LStat.^2)
machine(mdl, X3, y)
fit!(mach)
ŷ = predict(mach, X3)
round(rms(ŷ, y), sigdigits=4)
```

Unsurprisingly  the results are much  worse since we use far less information than before.

