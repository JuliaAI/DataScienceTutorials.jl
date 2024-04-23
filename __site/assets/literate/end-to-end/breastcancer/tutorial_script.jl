# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/end-to-end/breastcancer/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using UrlDownload
using DataFrames
using MLJ
using StatsBase
using StableRNGs # for an RNG stable across julia versions
MLJ.color_off(); # hide

url = "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data";
feature_names = ["ID", "Class", "mean radius", "mean texture", "mean perimeter", "mean area", "mean smoothness", "mean compactness", "mean concavity", "mean concave points", "mean symmetry", "mean fractal dimension", "radius error", "texture error", "perimeter error", "area error", "smoothness error", "compactness error", "concavity error", "concave points error", "symmetry error", "fractal dimension error", "worst radius", "worst texture", "worst perimeter", "worst area", "worst smoothness", "worst compactness", "worst concavity", "worst concave points", "worst symmetry", "worst fractal dimension"]
data = urldownload(url, true, format = :CSV, header = feature_names);

using Plots

Plots.bar(countmap(data.Class), legend=false,)
xlabel!("Classes")
ylabel!("Number of samples")
savefig(joinpath(@OUTPUT, "Target_class.svg")); # hide

df = DataFrame(data)[:, 2:end];

first(df,10)

describe(df)

schema(df)

coerce!(df, :Class => OrderedFactor{2});
scitype(df.Class)

rng = StableRNG(123)
y, X = unpack(df, ==(:Class); rng);

train, test = partition(eachindex(y), 0.8; rng)

transformer_instance = Standardizer()
transformer_model = machine(transformer_instance, X[train,:])
fit!(transformer_model)
X = MLJ.transform(transformer_model, X);

models(matching(X, y))

model_names=Vector{String}();
accuracies=[];
log_losses=[];
f1_scores=[];

models_to_evaluate = models(matching(X, y)) do m
    m.prediction_type==:probabilistic && m.is_pure_julia &&
        m.package_name != "SIRUS"
end

p = plot(legendfontsize=7, title="ROC Curve")
plot!([0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:black)
for m in models_to_evaluate
    model=m.name
    pkg = m.package_name
    model_name = "$model ($pkg)"
    @info "Evaluating $model_name. "
    eval(:(clf = @load $model pkg=$pkg verbosity=0))

    clf_machine = machine(clf(), X, y)
    fit!(clf_machine, rows=train, verbosity=0)

    y_pred = MLJ.predict(clf_machine, rows=test);

    fprs, tprs, thresholds = roc_curve(y_pred, y[test])
    plot!(p, fprs, tprs,label=model_name)
    gui()

    push!(model_names, model_name)
    push!(accuracies, accuracy(mode.(y_pred), y[test]))
    push!(log_losses, log_loss(y_pred,y[test]))
    push!(f1_scores, f1score(mode.(y_pred), y[test]))
end

#Adding labels and legend to the ROC-AUC curve
xlabel!("False Positive Rate (positive=malignant)")
ylabel!("True Positive Rate")

savefig(joinpath(@OUTPUT, "breastcancer_auc_curve.svg")); # hide

model_comparison=DataFrame(
    ModelName=model_names,
    Accuracy=accuracies,
    LogLoss=log_losses,
    F1Score=f1_scores
);

sort!(model_comparison, [:LogLoss])
