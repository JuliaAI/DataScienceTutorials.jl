using MLJ, StatsBase, Random, PyPlot, CategoricalArrays, PrettyPrinting
X, y = @load_crabs
@show size(X)
@show y[1:3]
first(X, 3) |> pretty

levels(y) |> pprint

train, test = partition(eachindex(y), 0.70, shuffle=true, rng=52)
@load XGBoostClassifier
xgb_model = XGBoostClassifier()

countmap(y[train]) |> pprint

xgb  = XGBoostClassifier()
xgbm = machine(xgb, X, y)

r = range(xgb, :num_round, lower=10, upper=500)
curve = learning_curve!(xgbm, resampling=CV(),
                        range=r, resolution=25,
                        measure=cross_entropy)

figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
xlabel("Number of rounds", fontsize=14)
ylabel("Cross entropy", fontsize=14)
xticks([10, 100, 250, 500], fontsize=12)
yticks(0.8:0.05:1, fontsize=12)



xgb.num_round = 100;

r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :min_child_weight, lower=0, upper=5)

tm = TunedModel(model=xgb, tuning=Grid(resolution=8),
                resampling=CV(rng=11), ranges=[r1,r2],
                measure=cross_entropy)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)

r = report(mtm)

md = r.parameter_values[:,1]
mcw = r.parameter_values[:,2]

figure(figsize=(8,6))
tricontourf(md, mcw, r.measurements)

xlabel("Maximum tree depth", fontsize=14)
ylabel("Minimum child weight", fontsize=14)
xticks(3:2:10, fontsize=12)
yticks(fontsize=12)



xgb = fitted_params(mtm).best_model
@show xgb.max_depth
@show xgb.min_child_weight

xgbm = machine(xgb, X, y)
r = range(xgb, :gamma, lower=0, upper=10)
curve = learning_curve!(xgbm, resampling=CV(),
                        range=r, resolution=30,
                        measure=cross_entropy);

@show round(minimum(curve.measurements), sigdigits=3)
@show round(maximum(curve.measurements), sigdigits=3)

r1 = range(xgb, :subsample, lower=0.6, upper=1.0)
r2 = range(xgb, :colsample_bytree, lower=0.6, upper=1.0)
tm = TunedModel(model=xgb, tuning=Grid(resolution=8),
                resampling=CV(rng=234), ranges=[r1,r2],
                measure=cross_entropy)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)

r = report(mtm)
ss = r.parameter_values[:,1]
cbt = r.parameter_values[:,2]

figure(figsize=(8,6))
tricontourf(ss, cbt, r.measurements)

xlabel("Sub sample", fontsize=14)
ylabel("Col sample by tree", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)



xgb = fitted_params(mtm).best_model
@show xgb.subsample
@show xgb.colsample_bytree

ŷ = predict_mode(mtm, rows=test)
round(misclassification_rate(ŷ, y[test]), sigdigits=3)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

