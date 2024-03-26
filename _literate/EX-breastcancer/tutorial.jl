using Pkg # hideall
Pkg.activate("_literate/EX-breastcancer/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;


# @@dropdown
# ## Introduction
# @@
# @@dropdown-content

# This tutorial covers programmatic model selection on the popular ["Breast Cancer
# Wisconsin (Diagnostic) Data
# Set"](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic)) from
# the UCI archives. The tutorial also covers basic data preprocessing and usage of MLJ
# Scientific Types.


# ‎
# @@
# @@dropdown
# ## Loading the relevant packages
# @@
# @@dropdown-content

using UrlDownload
using DataFrames
using MLJ
using StatsBase
using StableRNGs # for an RNG stable across julia versions
MLJ.color_off(); # hide

# ‎
# @@
# @@dropdown
# ## Downloading and loading the data
# @@
# @@dropdown-content

# Using the package UrlDownload.jl, we can capture the data from the given link using the below commands.

url = "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data";
feature_names = ["ID", "Class", "mean radius", "mean texture", "mean perimeter", "mean area", "mean smoothness", "mean compactness", "mean concavity", "mean concave points", "mean symmetry", "mean fractal dimension", "radius error", "texture error", "perimeter error", "area error", "smoothness error", "compactness error", "concavity error", "concave points error", "symmetry error", "fractal dimension error", "worst radius", "worst texture", "worst perimeter", "worst area", "worst smoothness", "worst compactness", "worst concavity", "worst concave points", "worst symmetry", "worst fractal dimension"]
data = urldownload(url, true, format = :CSV, header = feature_names);


# ‎
# @@
# @@dropdown
# ## Exploring the obtained data
# @@
# @@dropdown-content

# @@dropdown
# ### Inspecting the class variable
# @@
# @@dropdown-content
using Plots

Plots.bar(countmap(data.Class), legend=false,)
xlabel!("Classes")
ylabel!("Number of samples")
savefig(joinpath(@OUTPUT, "Target_class.svg")); # hide

# \figalt{Distribution of target classes}{Target_class.svg}

# ‎
# @@
# @@dropdown
# ### Inspecting the feature set
# @@
# @@dropdown-content
df = DataFrame(data)[:, 2:end];

# Printing the 1st 10 rows so as to get a visual idea about the type of data we're dealing
# with
first(df,10)

# For checking the statistical attributes of each inividual feature, we can use the
# __decsribe()__ method
describe(df)

# As we can see the feature set consists of varying features that have different ranges
# and quantiles. This can cause trouble for the optimization techniques and might cause
# convergence issues. We can use a feature scaling technique like __Standardizer()__ to
# handle this.

# But first, let's handle the [scientific
# types](https://alan-turing-institute.github.io/ScientificTypes.jl/dev/) of all the
# features. We can use the `schema()` method from MLJ.jl package to do this
schema(df)

# As `Textual` is a sciytype reserved for text data "with sentiment", we need to `coerce`
# the scitype to the more appropriate `OrderedFactor`:

coerce!(df, :Class => OrderedFactor{2});
scitype(df.Class)

# ‎
# @@

# ‎
# @@
# @@dropdown
# ## Unpacking the values
# @@
# @@dropdown-content

# Now that our data is fully processed, we can separate the target variable 'y' from the
# feature set 'X' using the __unpack()__ method.

rng = StableRNG(123)
y, X = unpack(df, ==(:Class); rng)


# We'll be using 80% of data for training, and can perform a train-test split using the
# `partition` method:
train, test = partition(eachindex(y), 0.8; rng)

# ‎
# @@
# @@dropdown
# ## Standardizing the "feature set"
# @@
# @@dropdown-content

# Now that our feature set is separated from the target variable, we can use
# the`Standardizer()` worklow to obtain to standardize our feature set `X`:

transformer_instance = Standardizer()
transformer_model = machine(transformer_instance, X[train,:])
fit!(transformer_model)
X = MLJ.transform(transformer_model, X);

# ‎
# @@
# @@dropdown
# ## Train-test split
# @@
# @@dropdown-content

# With feature scaling complete, we are ready to compare the performance of various
# machine learning models for classification.


# ‎
# @@
# @@dropdown
# ## Model compatibility
# @@
# @@dropdown-content

# Now that we have separate training and testing set, let's see the models compatible with our data!

models(matching(X, y))

# ‎
# @@
# @@dropdown
# ## Analyzing the performance of different models
# @@
# @@dropdown-content

# Thats a lot of models for our data! To narrow it down, we'll analyze the performance of
# probablistic predictors with pure julia implementations:

# @@dropdown
# ### Creating various empty vectors for our analysis
# @@
# @@dropdown-content
# - `model_names`: captures the names of the models being evaluated
# - `accuracies`: accuracies of the value of the model accuracy on the test set
# - `log_losses`: values of the log loss (cross entropy) on the test set
# - `f1_scores`:  captures the values of F1-Score on the test set

model_names=Vector{String}();
accuracies=[];
log_losses=[];
f1_scores=[];

# ‎
# @@
# @@dropdown
# ### Collecting data for analysis
# @@
# @@dropdown-content

models_to_evaluate = models(matching(X, y)) do m
    m.prediction_type==:probabilistic && m.is_pure_julia &&
        m.package_name != "SIRUS"
end

p = plot(legendfontsize=7, title="ROC Curve")
plot!([0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:black)
for m in models_to_evaluate
    # Capturing the model and loading it using the @load utility:
    model=m.name
    pkg = m.package_name
    model_name = "$model ($pkg)"
    @info "Evaluating $model_name. "
    eval(:(clf = @load $model pkg=$pkg verbosity=0))

    # Fitting the captured model onto the training set:
    clf_machine = machine(clf(), X, y)
    fit!(clf_machine, rows=train, verbosity=0)

    # Getting the predictions onto the test set
    y_pred = MLJ.predict(clf_machine, rows=test);

    # Each model gets an ROC-AUC curve:
    fprs, tprs, thresholds = roc_curve(y_pred, y[test])
    plot!(p, fprs, tprs,label=model_name)
    gui()

    # Calculate and save metrics:
    push!(model_names, model_name)
    push!(accuracies, accuracy(mode.(y_pred), y[test]))
    push!(log_losses, log_loss(y_pred,y[test]))
    push!(f1_scores, f1score(mode.(y_pred), y[test]))
end

#Adding labels and legend to the ROC-AUC curve
xlabel!("False Positive Rate (positive=malignant)")
ylabel!("True Positive Rate")

savefig(joinpath(@OUTPUT, "breastcancer_auc_curve.svg")); # hide
# \figalt{ROC-AUC Curve}{breastcancer_auc_curve.svg}


# ‎
# @@
# @@dropdown
# ### Inspecting results
# @@
# @@dropdown-content

# Let's collect the data in form a dataframe for a more precise analysis
model_comparison=DataFrame(
    ModelName=model_names,
    Accuracy=accuracies,
    LogLoss=log_losses,
    F1Score=f1_scores
);

# Finally, let's sort the data on basis of the log loss:

sort!(model_comparison, [:LogLoss])

# ‎
# @@

# ‎
# @@
