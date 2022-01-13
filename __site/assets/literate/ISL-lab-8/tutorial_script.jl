# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/ISL-lab-8/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
import RDatasets: dataset
using PrettyPrinting
import DataFrames: DataFrame, select, Not
MLJ.color_off() # hide
DTC = @load DecisionTreeClassifier pkg=DecisionTree

carseats = dataset("ISLR", "Carseats")

first(carseats, 3) |> pretty

High = ifelse.(carseats.Sales .<= 8, "No", "Yes") |> categorical;
carseats[!, :High] = High;

X = select(carseats, Not([:Sales, :High]))
y = carseats.High;

HotTreeClf = @pipeline(OneHotEncoder(),
                       DTC())

mdl = HotTreeClf
mach = machine(mdl, X, y)
fit!(mach);

ypred = predict_mode(mach, X)
misclassification_rate(ypred, y)

train, test = partition(eachindex(y), 0.5, shuffle=true, rng=333)
fit!(mach, rows=train)
ypred = predict_mode(mach, rows=test)
misclassification_rate(ypred, y[test])

r_mpi = range(mdl, :(decision_tree_classifier.max_depth), lower=1, upper=10)
r_msl = range(mdl, :(decision_tree_classifier.min_samples_leaf), lower=1, upper=50)

tm = TunedModel(model=mdl, ranges=[r_mpi, r_msl], tuning=Grid(resolution=8),
                resampling=CV(nfolds=5, rng=112),
                operation=predict_mode, measure=misclassification_rate)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)

ypred = predict_mode(mtm, rows=test)
misclassification_rate(ypred, y[test])

fitted_params(mtm).best_model.decision_tree_classifier

DTR = @load DecisionTreeRegressor pkg=DecisionTree

boston = dataset("MASS", "Boston")

y, X = unpack(boston, ==(:MedV))

train, test = partition(eachindex(y), 0.5, shuffle=true, rng=551);

scitype(X)

X = coerce(X, autotype(X, rules=(:discrete_to_continuous,)))

dtr_model = DTR()
dtr = machine(dtr_model, X, y)

fit!(dtr, rows=train)

ypred = MLJ.predict(dtr, rows=test)
round(rms(ypred, y[test]), sigdigits=3)

r_depth = range(dtr_model, :max_depth, lower=2, upper=20)

tm = TunedModel(model=dtr_model, ranges=[r_depth], tuning=Grid(resolution=10),
                resampling=CV(nfolds=5, rng=1254), measure=rms)
mtm = machine(tm, X, y)

fit!(mtm, rows=train)

ypred = MLJ.predict(mtm, rows=test)
round(rms(ypred, y[test]), sigdigits=3)

RFR = @load RandomForestRegressor pkg=ScikitLearn

rf_mdl = RFR()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

ypred = MLJ.predict(rf, rows=test)
round(rms(ypred, y[test]), sigdigits=3)

XGBR = @load XGBoostRegressor

xgb_mdl = XGBR(num_round=10, max_depth=10)
xgb = machine(xgb_mdl, X, y)
fit!(xgb, rows=train)

ypred = MLJ.predict(xgb, rows=test)
round(rms(ypred, y[test]), sigdigits=3)

