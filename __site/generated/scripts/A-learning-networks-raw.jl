# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using MLJ, StableRNGs
import DataFrames

@load RidgeRegressor pkg=MultivariateStats

rng = StableRNG(551234) # for reproducibility

x1 = rand(rng, 300)
x2 = rand(rng, 300)
x3 = rand(rng, 300)
y = exp.(x1 - x2 -2x3 + 0.1*rand(rng, 300))

X = DataFrames.DataFrame(x1=x1, x2=x2, x3=x3)
first(X, 3) |> pretty

test, train = partition(eachindex(y), 0.8);

Xs = source(X)
ys = source(y)

stand = machine(Standardizer(), Xs)
W = transform(stand, Xs)

fit!(W, rows=train);

W()             # transforms all data
W(rows=test, )  # transforms only test data
W(X[3:4, :])    # transforms specific data

box_model = UnivariateBoxCoxTransformer()
box = machine(box_model, ys)
z = transform(box, ys)

ridge_model = RidgeRegressor(lambda=0.1)
ridge = machine(ridge_model, W, z)
ẑ = predict(ridge, W)

ŷ = inverse_transform(box, ẑ)

fit!(ŷ, rows=train);

rms(y[test], ŷ(rows=test))

ridge_model.lambda = 5.0;

fit!(ŷ, rows=train)
rms(y[test], ŷ(rows=test))

W = X |> Standardizer()
z = y |> UnivariateBoxCoxTransformer()

ẑ = (W, z) |> RidgeRegressor(lambda=0.1);

ŷ = ẑ |> inverse_transform(z);

fit!(ŷ, rows=train)
rms(y[test], ŷ(rows=test))

ẑ[:lambda] = 5.0;

ẑ.machine.model.lambda = 5.0;

fit!(ŷ, rows=train)
rms(y[test], ŷ(rows=test))

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

