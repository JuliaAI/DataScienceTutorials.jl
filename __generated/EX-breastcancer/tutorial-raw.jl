# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/EX-breastcancer/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/EX-breastcancer/Manifest.toml).
# For instance, copy these files to a folder 'EX-breastcancer', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```


Pkg.activate("_literate/EX-breastcancer/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using UrlDownload
using DataFrames
using PrettyPrinting
using PyPlot
using MLJ



RANDOM_SEED = 42;

url = "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data";
feature_names = ["ID", "Class", "mean radius", "mean texture", "mean perimeter", "mean area", "mean smoothness", "mean compactness", "mean concavity", "mean concave points", "mean symmetry", "mean fractal dimension", "radius error", "texture error", "perimeter error", "area error", "smoothness error", "compactness error", "concavity error", "concave points error", "symmetry error", "fractal dimension error", "worst radius", "worst texture", "worst perimeter", "worst area", "worst smoothness", "worst compactness", "worst concavity", "worst concave points", "worst symmetry", "worst fractal dimension"]
data = urldownload(url, true, format = :CSV, header = feature_names);

figure(figsize=(8, 6))
hist(data.Class)
xlabel("Classes")
ylabel("Number of samples")


df = DataFrame(data)[:, 2:end];

pprint(first(df,10))

pprint(describe(df))

pprint(schema(df))

coerce!(df, :Class => OrderedFactor{2});

y, X = unpack(df, ==(:Class),name->true, rng = RANDOM_SEED);

transformer_instance = Standardizer()
transformer_model = machine(transformer_instance, X)
fit!(transformer_model)
X = MLJ.transform(transformer_model, X);

train, test = partition(eachindex(y), 0.8, shuffle=true, rng=RANDOM_SEED);

for m in models(matching(X, y))
    println("Model name = ",m.name,", ","Prediction type = ",m.prediction_type,", ","Package name = ",m.package_name);
end

model_names=Vector{String}();
loss_acc=[];
loss_ce=[];
loss_f1=[];

figure(figsize=(8, 6))
for m in models(matching(X, y))
    if m.prediction_type==Symbol("probabilistic") && m.package_name=="ScikitLearn" && m.name!="LogisticCVClassifier"
        #Excluding LogisticCVClassfiier as we can infer similar baseline results from the LogisticClassifier

        #Capturing the model and loading it using the @load utility
        model_name=m.name
        package_name=m.package_name
        eval(:(clf = @load $model_name pkg=$package_name verbosity=1))

        #Fitting the captured model onto the training set
        clf_machine = machine(clf(), X, y)
        fit!(clf_machine, rows=train)

        #Getting the predictions onto the test set
        y_pred = MLJ.predict(clf_machine, rows=test);

        #Plotting the ROC-AUC curve for each model being iterated
        fprs, tprs, thresholds = roc(y_pred, y[test])
        plot(fprs, tprs,label=model_name);

        #Obtaining different evaluation metrics
        ce_loss = mean(cross_entropy(y_pred,y[test]))
        acc = accuracy(mode.(y_pred), y[test])
        f1_score = f1score(mode.(y_pred), y[test])

        #Adding the different obtained values of the evaluation metrics to the respective vectors
        push!(model_names, m.name)
        append!(loss_acc, acc)
        append!(loss_ce, ce_loss)
        append!(loss_f1, f1_score)
    end
end

#Adding labels and legend to the ROC-AUC curve
xlabel("False Positive Rate")
ylabel("True Positive Rate")
legend(loc="best", fontsize="xx-small")
title("ROC curve")


model_info=DataFrame(ModelName=model_names,Accuracy=loss_acc,CrossEntropyLoss=loss_ce,F1Score=loss_f1);

pprint(sort!(model_info,[:CrossEntropyLoss]));

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

