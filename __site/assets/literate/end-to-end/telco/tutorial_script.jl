# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/end-to-end/telco")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ

X_iris, y_iris = @load_iris;
schema(X_iris)

y_iris[1:4]

levels(y_iris)

DecisionTree = @load DecisionTreeClassifier pkg=DecisionTree # model type
model = DecisionTree(min_samples_split=5)                    # model instance

mach = machine(model, X_iris, y_iris)

train_rows = vcat(1:60, 91:150); # some row indices (observations are rows not columns)
fit!(mach, rows=train_rows)
fitted_params(mach)

mach.model.min_samples_split  = 10
fit!(mach, rows=train_rows) # re-train with new hyper-parameter

predict(mach, rows=71:73)

Xnew = (sepal_length = [5.1, 6.3],
        sepal_width = [3.0, 2.5],
        petal_length = [1.4, 4.9],
        petal_width = [0.3, 1.5])
yhat = predict(mach, Xnew)

pdf.(yhat, "virginica")

yhat[2]

import DataFrames

data = OpenML.load(42178) # data set from OpenML.org
df0 = DataFrames.DataFrame(data)
first(df0, 4)

scitype(["cat", "mouse", "dog"])

schema(df0) |> DataFrames.DataFrame  # converted to DataFrame for better display

fix_blanks(v) = map(v) do x
    if x == " "
        return "0.0"
    else
        return x
    end
end

df0.TotalCharges = fix_blanks(df0.TotalCharges);

coerce!(df0, :TotalCharges => Continuous);

coerce!(df0, Textual => Multiclass);

coerce!(df0, :Churn => OrderedFactor)
levels(df0.Churn) # to check order

schema(df0) |> DataFrames.DataFrame

import Random.Xoshiro
rng = Xoshiro(123)
df, df_test, df_dumped = partition(df0, 0.07, 0.03; # in ratios 7:3:90
                                   stratify=df0.Churn,
                                   rng=rng);

y, X = unpack(df, ==(:Churn), !=(:customerID));
schema(X).names

intersect([:Churn, :customerID], schema(X).names)

ytest, Xtest = unpack(df_test, ==(:Churn), !=(:customerID));

Booster = @load EvoTreeClassifier pkg=EvoTrees

booster = Booster()

scitype(y) <: target_scitype(booster)

scitype(X) <: input_scitype(booster)

models(matching(X, y))

pipe = ContinuousEncoder() |> booster

pipe.evo_tree_classifier.max_depth

measures("Brier")

mach_pipe = machine(pipe, X, y)

train, validation = partition(1:length(y), 0.7)
fit!(mach_pipe, rows=train)

fp = fitted_params(mach_pipe);
keys(fp)

fp.evo_tree_classifier.fitresult

rpt = report(mach_pipe);
keys(rpt.continuous_encoder)

join(string.(rpt.continuous_encoder.new_features), ", ") |> println

reports_feature_importances(pipe)

Pkg.status()

reports_feature_importances(booster)

fi = feature_importances(mach_pipe)

feature_importance_table =
    (feature=Symbol.(first.(fi)), importance=last.(fi)) |> DataFrames.DataFrame;

ŷ = predict(mach_pipe, rows=validation);
print(
    "Measurements:\n",
    "  brier loss: ", brier_loss(ŷ, y[validation]), "\n",
    "  auc:        ", auc(ŷ, y[validation]),                "\n",
    "  accuracy:   ", accuracy(mode.(ŷ), y[validation])
)

confmat(mode.(ŷ), y[validation])

using Plots
Plots.scalefontsizes() #hide # reset font sizes
Plots.scalefontsizes(0.85)

roc = roc_curve(ŷ, y[validation])
plt = scatter(roc, legend=false)
plot!(plt, xlab="false positive rate", ylab="true positive rate")
plot!([0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:black)

savefig(joinpath(@OUTPUT, "EX-telco-roc.svg")); # hide

e_pipe = evaluate(pipe, X, y,
                  resampling=StratifiedCV(nfolds=6, rng=rng),
                  measures=[brier_loss, auc, accuracy],
                  repeats=3,
                  acceleration=CPUThreads())

unimportant_features = filter(:importance => <(0.005), feature_importance_table).feature

pipe2 = ContinuousEncoder() |>
    FeatureSelector(features=unimportant_features, ignore=true) |> booster

controls = [
    Step(1),              # to increment iteration parameter (`pipe.nrounds`)
    NumberSinceBest(4),   # main stopping criterion
    TimeLimit(2/3600),    # never train more than 2 sec
    InvalidValue()        # stop if NaN or ±Inf encountered
]

iterated_pipe = IteratedModel(model=pipe2,
                              controls=controls,
                              measure=brier_loss,
                              resampling=Holdout(fraction_train=0.7))

mach_iterated_pipe = machine(iterated_pipe, X, y)
fit!(mach_iterated_pipe);

show(iterated_pipe, 2)

p1 = :(model.evo_tree_classifier.eta)
p2 = :(model.evo_tree_classifier.max_depth)

r1 = range(iterated_pipe, p1, lower=-2, upper=-0.5, scale=x->10^x)
r2 = range(iterated_pipe, p2, lower=2, upper=6)

tuning = RandomSearch(rng=rng)

tuned_iterated_pipe = TunedModel(model=iterated_pipe,
                                 range=[r1, r2],
                                 tuning=tuning,
                                 measures=[brier_loss, auc, accuracy],
                                 resampling=StratifiedCV(nfolds=6, rng=rng),
                                 acceleration=CPUThreads(),
                                 n=40)

mach_tuned_iterated_pipe = machine(tuned_iterated_pipe, X, y)
fit!(mach_tuned_iterated_pipe)

rpt2 = report(mach_tuned_iterated_pipe);
best_booster = rpt2.best_model.model.evo_tree_classifier

print(
    "Optimal hyper-parameters: \n",
    "  max_depth: ", best_booster.max_depth, "\n",
    "  eta:         ", best_booster.eta
)

e_best = rpt2.best_history_entry
e_best.evaluation

rpt2.best_report.controls |> collect

plot(mach_tuned_iterated_pipe, size=(600,450))

savefig(joinpath(@OUTPUT, "EX-telco-tuning.svg")); # hide

FILE = joinpath(tempdir(), "tuned_iterated_pipe.jls")
MLJ.save(FILE, mach_tuned_iterated_pipe)

e_tuned_iterated_pipe = evaluate(tuned_iterated_pipe, X, y,
                                 resampling=StratifiedCV(nfolds=6, rng=rng),
                                 measures=[brier_loss, auc, accuracy])

e_pipe

mach_restored = machine(FILE)

ŷ_tuned = predict(mach_restored, Xtest);
ŷ_tuned[1]

print(
    "Tuned model measurements on test:\n",
    "  brier loss: ", brier_loss(ŷ_tuned, ytest), "\n",
    "  auc:        ", auc(ŷ_tuned, ytest),                "\n",
    "  accuracy:   ", accuracy(mode.(ŷ_tuned), ytest)
)

mach_basic = machine(pipe, X, y)
fit!(mach_basic, verbosity=0)

ŷ_basic = predict(mach_basic, Xtest);

print(
    "Basic model measurements on test set:\n",
    "  brier loss: ", brier_loss(ŷ_basic, ytest), "\n",
    "  auc:        ", auc(ŷ_basic, ytest),                "\n",
    "  accuracy:   ", accuracy(mode.(ŷ_basic), ytest)
)

rm(FILE) # hide
