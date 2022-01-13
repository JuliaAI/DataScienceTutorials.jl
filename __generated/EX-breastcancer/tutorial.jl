# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/EX-breastcancer/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/EX-breastcancer/Manifest.toml).
# For instance, copy these files to a folder 'EX-breastcancer', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Introduction
# This tutorial covers the concepts of iterative model selection on the popular ["Breast Cancer Wisconsin (Diagnostic) Data Set"](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic))
# from the UCI archives. The tutorial also covers basic data preprocessing and usage of MLJ Scientific Types.

# ## Loading the relevant packages
# For a guide to package intsllation in Julia please refer this [link](https://docs.julialang.org/en/v1/stdlib/Pkg/) taken directly from Juliav1 documentation

using UrlDownload
using DataFrames
using PrettyPrinting
using PyPlot
using MLJ

# Inititalizing a global random seed which we'll use throughout the code to maintain consistency in results

RANDOM_SEED = 42;

# ## Downloading and loading the data
# Using the package UrlDownload.jl, we can capture the data from the given link using the below commands

url = "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data";
feature_names = ["ID", "Class", "mean radius", "mean texture", "mean perimeter", "mean area", "mean smoothness", "mean compactness", "mean concavity", "mean concave points", "mean symmetry", "mean fractal dimension", "radius error", "texture error", "perimeter error", "area error", "smoothness error", "compactness error", "concavity error", "concave points error", "symmetry error", "fractal dimension error", "worst radius", "worst texture", "worst perimeter", "worst area", "worst smoothness", "worst compactness", "worst concavity", "worst concave points", "worst symmetry", "worst fractal dimension"]
data = urldownload(url, true, format = :CSV, header = feature_names);

# ## Exploring the obtained data
# ### Inspecting the class variable

figure(figsize=(8, 6))
hist(data.Class)
xlabel("Classes")
ylabel("Number of samples")

# \figalt{Distribution of target classes}{Target_class.svg}

# ### Inspecting the feature set

df = DataFrame(data)[:, 2:end];

# Printing the 1st 10 rows so as to get a visual idea about the type of data we're dealing with

pprint(first(df,10))

# For checking the statistical attributes of each inividual feature, we can use the __decsribe()__ method

pprint(describe(df))

# As we can see the feature set consists of varying features that have different ranges and quantiles. This can cause trouble for the optimization techniques and might cause convergence
# issues. We can use a feature scaling technique like __Standardizer()__ to handle this.

# But first, let's handle the [scientific types](https://alan-turing-institute.github.io/ScientificTypes.jl/dev/) of all the features. We can use the schema() method from MLJ.jl package to do this

pprint(schema(df))

# As the target variable is 'Textual' in nature, we'll have to change it to a more appropriate scientific type. Using the __coerce()__ method, let's change it to an OrderedFactor.

coerce!(df, :Class => OrderedFactor{2});

# ## Unpacking the values
# Now that our data is fully processed, we can separate the target variable 'y' from the feature set 'X' using the __unpack()__ method.

y, X = unpack(df, ==(:Class),name->true, rng = RANDOM_SEED);

# ## Standardizing the "feature set"
# Now that our feature set is separated from the target variable, we can use the __Standardizer()__ worklow to obtain to standadrize our feature set 'X'.

transformer_instance = Standardizer()
transformer_model = machine(transformer_instance, X)
fit!(transformer_model)
X = MLJ.transform(transformer_model, X);

# ## Train-test split
# After feature scaling, our data is ready to put into a Machine Learning model for classification! Using 80% of data for training, we can perform a train-test split using the __partition()__ method.

train, test = partition(eachindex(y), 0.8, shuffle=true, rng=RANDOM_SEED);

# ## Model compatibility
# Now that we have separate training and testing set, let's see the models compatible with our data!

for m in models(matching(X, y))
    println("Model name = ",m.name,", ","Prediction type = ",m.prediction_type,", ","Package name = ",m.package_name);
end

# ## Analyzing the performance of different models
# Thats a lot of models for our data! To narrow it down, lets analyze the performance of "probabilistic classifiers" from the "ScikitLearn" package.

# ### Creating various empty vectors for our analysis
# - __model_names__ captures the names of the models being iterated
# - __loss_acc captures__ the value of the model accuracy on the test set
# - __loss_ce captures__ the values of the Cross-entropy loss on the test set
# - __loss_f1__ captures the values of F1-Score on the test set

model_names=Vector{String}();
loss_acc=[];
loss_ce=[];
loss_f1=[];

# ### Collecting data for analysis

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

# \figalt{ROC-AUC Curve}{breastcancer_auc_curve.svg}

# ### Analyzing models
# Let's collect the data in form a dataframe for a more precise analysis

model_info=DataFrame(ModelName=model_names,Accuracy=loss_acc,CrossEntropyLoss=loss_ce,F1Score=loss_f1);

# Now, let's sort the data on basis of the Cross-entropy loss

pprint(sort!(model_info,[:CrossEntropyLoss]));

# It seems like a simple LogisticClassifier works really well with this dataset!

# # Conclusion
# This article covered iterative feature selection on the Breast cancer classification dataset. In this tutorial, we only analyzed the __ScikitLearn__
# models so as to keep the flow of the content precise, but the same workflow can be applied to any compatible model in the __MLJ__ family.

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

