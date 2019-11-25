# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Simple linear regression## `MLJ` essentially serves as a unified path to many existing Julia packages each of which provides their own functionalities and models, with their own conventions.## The simple linear regression demonstrates this.# Several packages offer it (beyond just using the backslash operator): here we will use `MLJLinearModels` but we could also have used `GLM`, `ScikitLearn` etc.## To load the model from a given package use `@load ModelName pkg=PackageName`
using MLJ

@load LinearRegressor pkg=MLJLinearModels

# Note: in order to be able to load this, you **must** have the relevant package in your environment, if you don't, you can always add it (``using Pkg; Pkg.add("MLJLinearModels")``).## Let's load the _boston_ data set
using RDatasets, DataFrames
boston = dataset("MASS", "Boston")
first(boston, 3)

# Let's get a feel for the data
describe(boston, :mean, :std, :eltype)

# So there's no missing value and most variables are encoded as floating point numbers.# In MLJ it's important to specify the interpretation of the features (should it be considered as a Continuous feature, as a Count, ...?), see also [this tutorial section](/pub/getting-started/choosing-a-model.html#data_and_its_interpretation) on scientific types.## Here we will just interpret the integer features as continuous as we will just use a basic linear regression; the [`ScientificTypes`](https://github.com/alan-turing-institute/ScientificTypes.jl) package helps us with that:
using ScientificTypes
data = coerce(boston, autotype(boston, :discrete_to_continuous));

# Let's also extract the target variable (`MedV`):
y = data.MedV
X = select(data, Not(:MedV));

# Let's declare a simple multivariate linear regression model:
mdl = LinearRegressor()

# In order to fit it on the data, we need to wrap it in a _machine_ which, in MLJ, is the composition of a model and data to apply the model on:
mach = machine(mdl, X, y)
fit!(mach)

# The `fit!` operation trains the model on the data and the results are kept inside of the machine.# In this case we have trained it on the whole data.# You can retrieve the fitted parameters using `fitted_params`:
fp = fitted_params(mach)
@show round.(fp.coefs[1:3], sigdigits=3)
@show round(fp.intercept, sigdigits=3)

# You can use the `machine` in order to _predict_ values as well and, for instance, compute the root mean squared error:
ŷ = predict(mach, X)
round(rms(ŷ, y), sigdigits=4)

# Let's see what the residuals look like
using PyPlot

figure(figsize=(8,6))
res = ŷ .- y
stem(res)



# ![Plot of the residuals](/assets/literate/ISL-lab-3-res.svg)
# Maybe that a histogram is more appropriate here
figure(figsize=(8,6))
hist(res, density=true)
x = range(-20, 20, )



# ![Histogram of the residuals](/assets/literate/ISL-lab-3-res2.svg)
# ## Interaction and transformation## Let's say we want to also consider an interaction term of `lstat` and `age` taken together.# To do this, just create a new dataframe with an additional column corresponding to the interaction term:
X2 = hcat(X, X.LStat .* X.Age);

# So here we have a DataFrame with one extra column corresponding to the elementwise products between `:LStat` and `Age`.# DataFrame gives this a default name (`:x1`) which we can change:
rename!(X2, :x1 => :interaction);

# Ok cool, now let's try the linear regression again
mach = machine(mdl, X2, y)
fit!(mach)
ŷ = predict(mach, X2)
round(rms(ŷ, y), sigdigits=4)

# We get slightly better results but nothing spectacular.## Let's get back to the lab where they consider regressing the target variable on `lstat` and `lstat^2`; again, it's essentially a case of defining the right DataFrame:
X3 = hcat(X.LStat, X.LStat.^2)
machine(mdl, X3, y)
fit!(mach)
ŷ = predict(mach, X3)
round(rms(ŷ, y), sigdigits=4)

# Unsurprisingly  the results are much  worse since we use far less information than before.
# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

