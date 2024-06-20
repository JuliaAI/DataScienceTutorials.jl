using MLJ
using StatsBase
using Random
using Plots
import DataFrames
import StableRNGs.StableRNG


X, y = @load_crabs # a table and a vector
X = DataFrames.DataFrame(X)
@show size(X)
@show y[1:3]
first(X, 3)

schema(X)

levels(y)

train, test = partition(collect(eachindex(y)), 0.70, rng=StableRNG(123))
XGBC = @load XGBoostClassifier
xgb_model = XGBC()

countmap(y[train])

xgb  = XGBC()
mach = machine(xgb, X, y)

r = range(xgb, :num_round, lower=50, upper=500)
curve = learning_curve(
    mach,
    range=r,
    resolution=50,
    measure=brier_loss,
)

plot(curve.parameter_values, curve.measurements)
xlabel!("Number of rounds", fontsize=14)
ylabel!("Brier loss", fontsize=14)

xgb.num_round = 300;

r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :min_child_weight, lower=0, upper=5)

tuned_model = TunedModel(
    xgb,
    tuning=Grid(resolution=8),
    resampling=CV(rng=11),
    ranges=[r1,r2],
    measure=brier_loss,
)
mach = machine(tuned_model, X, y)
fit!(mach, rows=train)

plot(mach)

xgb = fitted_params(mach).best_model
@show xgb.max_depth
@show xgb.min_child_weight

mach = machine(xgb, X, y)
curve = learning_curve(
    mach,
    range= range(xgb, :gamma, lower=0, upper=10),
    resolution=30,
    measure=brier_loss,
);

plot(curve.parameter_values, curve.measurements)
xlabel!("gamma", fontsize=14)
ylabel!("Brier loss", fontsize=14)

xgb.gamma = 3.8

r1 = range(xgb, :subsample, lower=0.6, upper=1.0)
r2 = range(xgb, :colsample_bytree, lower=0.6, upper=1.0)

tuned_model = TunedModel(
    xgb,
    tuning=Grid(resolution=8),
    resampling=CV(rng=234),
    ranges=[r1,r2],
    measure=brier_loss,
)
mach = machine(tuned_model, X, y)
fit!(mach, rows=train)

plot(mach)

xgb = fitted_params(mach).best_model
@show xgb.subsample
@show xgb.colsample_bytree

ŷ = predict_mode(mach, rows=test)
round(accuracy(ŷ, y[test]), sigdigits=3)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
