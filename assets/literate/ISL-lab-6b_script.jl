# This file was generated, do not modify it.

using MLJ, RDatasets, ScientificTypes, PrettyPrinting

@load LinearRegressor pkg=MLJLinearModels
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

