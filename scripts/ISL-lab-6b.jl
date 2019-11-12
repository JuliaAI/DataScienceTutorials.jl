# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using MLJ, RDatasets, ScientificTypes, PrettyPrinting

@load RidgeRegressor pkg=MLJLinearModels
@load LassoRegressor pkg=MLJLinearModels

hitters = dataset("ISLR", "Hitters")
@show size(hitters)
names(hitters) |> pprint

y, X = unpack(hitters, ==(:Salary), col->true);

no_miss = .!ismissing.(y)
y = collect(skipmissing(y))
X = X[no_miss, :]
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=424);

Xc = coerce(X, autotype(X, rules=(:discrete_to_continuous,)))
scitype(Xc)

@pipeline HotReg(hot = OneHotEncoder(),
                 reg = LinearRegressor())

model = HotReg()
pipe1 = machine(model, Xc, y)
fit!(pipe1, rows=train)
ŷ = predict(pipe1, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)

model.reg = RidgeRegressor()
pipe2 = machine(model, Xc, y)
fit!(pipe2, rows=train)
ŷ = predict(pipe2, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)

r  = range(model, :(reg.lambda), lower=1e-2, upper=1e9, scale=:log10)
tm = TunedModel(model=model, ranges=r, tuning=Grid(resolution=50),
                measure=rms)
mtm = machine(tm, Xc, y)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
@show round(best_mdl.reg.lambda, sigdigits=4)

ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)

Xc2 = select(Xc, Not([:League, :Division, :NewLeague]))
pipe2 = machine(model, Xc2, y)
fit!(pipe2, rows=train)
ŷ = predict(pipe2, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)

tm.resampling = CV(nfolds=5)
mtm = machine(tm, Xc2, y)
fit!(mtm, rows=train)

ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

