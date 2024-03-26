using Pkg # hideall
Pkg.activate("_literate/EX-wine/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;


# @@dropdown
# ## Initial data processing
# @@
# @@dropdown-content
#
# In this example, we consider the [UCI "wine" dataset](http://archive.ics.uci.edu/ml/datasets/wine)
#
# > These data are the results of a chemical analysis of wines grown in the same region in Italy but derived from three different cultivars. The analysis determined the quantities of 13 constituents found in each of the three types of wines.
#

# @@dropdown
# ### Getting the data
# @@
# @@dropdown-content
#
# Let's download the data thanks to the [UrlDownload.jl](https://github.com/Arkoniak/UrlDownload.jl) package and load it into a DataFrame:

using HTTP
using MLJ
using StableRNGs # for RNGs, stable over Julia versions
import DataFrames: DataFrame, describe
using UrlDownload
MLJ.color_off() # hide

url = "http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data"
header = ["Class", "Alcool", "Malic acid", "Ash", "Alcalinity of ash",
          "Magnesium", "Total phenols", "Flavanoids",
          "Nonflavanoid phenols", "Proanthcyanins", "Color intensity",
          "Hue", "OD280/OD315 of diluted wines", "Proline"]
data = urldownload(url, true, format=:CSV, header=header);

# The second argument to `urldownload` adds a progress meter for the download,
# the `format` helps indicate the format of the file and the `header` helps
# pass the column names which are not in the file.

df = DataFrame(data)
describe(df)

# the target is the `Class` column, everything else is a feature; we can
# dissociate the two  using the `unpack` function:

y, X = unpack(df, ==(:Class)); # a vector and a table


# ‎
# @@
# @@dropdown
# ### Setting the scientific type
# @@
# @@dropdown-content
#
# Let's explore the scientific type attributed by default to the target and the features

scitype(y)

# this should be changed as it should be considered as an ordered factor. The
# difference is as follows:
#
# * a `Count` corresponds to an integer between 0 and infinity
# * a `OrderedFactor` however is a categorical object (there are finitely many options) with ordering (`1 < 2 < 3`).
#

yc = coerce(y, OrderedFactor);

# Let's now consider the features. Since this is a table, will inspect scitypes using
# `schema`, which is more user-friendly:

schema(X)

# So there are `Continuous` values (encoded as floating point) and `Count` values
# (integer).  Note also that there are no missing value (otherwise one of the scientific
# type would have been a `Union{Missing,*}`).  Let's check which column is what: The two
# variables that are encoded as `Count` can probably be re-interpreted; let's have a look
# at the `Proline` one to see what it looks like

X[1:5, :Proline]

# This is likely representing a `Continuous` variable as well (it would be better to know precisely what it is but for now let's just go with the hunch).
# We'll do the same with `:Magnesium`:

Xc = coerce(X, :Proline=>Continuous, :Magnesium=>Continuous);

# Finally, let's have a quick look at the mean and standard deviation of each feature to get a feel for their amplitude:

describe(Xc, :mean, :std)

# Right so it varies a fair bit which would invite to standardise the data.
#
# **Note**: to complete such a first step, one could explore histograms of the various
# **features for instance, check that there is enough variation among the continuous
# **features and that there does not seem to be problems in the encoding, we cut this out
# **to shorten the tutorial. We could also have checked that the data is balanced.
#

# ‎
# @@

# ‎
# @@
# @@dropdown
# ## Getting a baseline
# @@
# @@dropdown-content
#
# It's a multiclass classification problem with continuous inputs so a sensible start is
# to test two very simple classifiers to get a baseline.

# We'll train two simple pipelines:
# - a Standardizer + KNN classifier and
# - a Standardizer + Multinomial classifier (logistic regression).

KNNClassifier = @load KNNClassifier
MultinomialClassifier = @load MultinomialClassifier pkg=MLJLinearModels;

knn_pipe = Standardizer() |> KNNClassifier()
multinom_pipe = Standardizer() |> MultinomialClassifier()

# Note the `|>` syntax, which is syntactic sugar for creating a linear `Pipeline`.

# We can now fit this on a train split of the data setting aside 20% of the data for
# eventual testing.

(Xtrain, Xtest), (ytrain, ytest) =
    partition((Xc, yc), 0.8, rng=StableRNG(123), multi=true)

# Let's now wrap an instance of these models with data (all hyperparameters are set to
# default here):

knn = machine(knn_pipe, Xtrain, ytrain)
multinom = machine(multinom_pipe, Xtrain, ytrain)

# Let's train a KNNClassifier with default hyperparameters and get a baseline
# misclassification rate using 90% of the training data to train the model and the
# remaining 10% to evaluate it:

opts = (
    resampling=Holdout(fraction_train=0.9),
    measures=[log_loss, accuracy],
)
evaluate!(knn; opts...)


# Now we do the same with a MultinomialClassifier

evaluate!(multinom; opts...)


# Both methods have perfect out-of-sample accuracy, without any tuning!

# Let's check the accuracy on the test set:

fit!(knn) # train on all train data
yhat = predict_mode(knn, Xtest)
accuracy(yhat, ytest)

# Still pretty good.

fit!(multinom) # train on all train data
yhat = predict_mode(multinom, Xtest)
accuracy(yhat, ytest)

# Even better.

# ‎
# @@
# @@dropdown
# ## Visualising the classes
# @@
# @@dropdown-content
#
# One way to get intuition for why the dataset is so easy to classify is to project it onto a 2D space using the PCA and display the two classes to see if they are well separated; we use the arrow-syntax here (if you're on Julia <= 1.2, use the commented-out lines as you won't be able to use the arrow-syntax)

PCA = @load PCA
pca_pipe = Standardizer() |> PCA(maxoutdim=2)
pca = machine(pca_pipe, Xtrain)
fit!(pca)
W = transform(pca, Xtrain)

# Let's now display this using different colours for the different classes:

x1 = W.x1
x2 = W.x2

mask_1 = ytrain .== 1
mask_2 = ytrain .== 2
mask_3 = ytrain .== 3

using Plots
Plots.scalefontsizes() #hide
Plots.scalefontsizes(1.2) #hide

scatter(x1[mask_1], x2[mask_1], color="red", label="Class 1")
scatter!(x1[mask_2], x2[mask_2], color="blue", label="Class 2")
scatter!(x1[mask_3], x2[mask_3], color="yellow", label="Class 3")

xlabel!("PCA dimension 1")
ylabel!("PCA dimension 2")

savefig(joinpath(@OUTPUT, "EX-wine-pca.svg")); # hide

# \figalt{PCA}{EX-wine-pca.svg}
#
# From the figure it's clear why we managed to achieve such high scores with very simple
# classifiers.  At this point it's a bit pointless to dig much deaper into parameter
# tuning etc.
#

# ‎
# @@
