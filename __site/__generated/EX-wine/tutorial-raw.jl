using HTTP
using MLJ
using StableRNGs # for RNGs, stable over Julia versions
import DataFrames: DataFrame, describe
using UrlDownload

url = "http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data"
header = ["Class", "Alcool", "Malic acid", "Ash", "Alcalinity of ash",
          "Magnesium", "Total phenols", "Flavanoids",
          "Nonflavanoid phenols", "Proanthcyanins", "Color intensity",
          "Hue", "OD280/OD315 of diluted wines", "Proline"]
data = urldownload(url, true, format=:CSV, header=header);

df = DataFrame(data)
describe(df)

y, X = unpack(df, ==(:Class)); # a vector and a table

scitype(y)

yc = coerce(y, OrderedFactor);

schema(X)

X[1:5, :Proline]

Xc = coerce(X, :Proline=>Continuous, :Magnesium=>Continuous);

describe(Xc, :mean, :std)

KNNClassifier = @load KNNClassifier
MultinomialClassifier = @load MultinomialClassifier pkg=MLJLinearModels;

knn_pipe = Standardizer() |> KNNClassifier()
multinom_pipe = Standardizer() |> MultinomialClassifier()

(Xtrain, Xtest), (ytrain, ytest) =
    partition((Xc, yc), 0.8, rng=StableRNG(123), multi=true);

knn = machine(knn_pipe, Xtrain, ytrain)
multinom = machine(multinom_pipe, Xtrain, ytrain)

opts = (
    resampling=Holdout(fraction_train=0.9),
    measures=[log_loss, accuracy],
)
evaluate!(knn; opts...)

evaluate!(multinom; opts...)

fit!(knn) # train on all train data
yhat = predict_mode(knn, Xtest)
accuracy(yhat, ytest)

fit!(multinom) # train on all train data
yhat = predict_mode(multinom, Xtest)
accuracy(yhat, ytest)

PCA = @load PCA
pca_pipe = Standardizer() |> PCA(maxoutdim=2)
pca = machine(pca_pipe, Xtrain)
fit!(pca)
W = transform(pca, Xtrain);

x1 = W.x1
x2 = W.x2

mask_1 = ytrain .== 1
mask_2 = ytrain .== 2
mask_3 = ytrain .== 3

using Plots

scatter(x1[mask_1], x2[mask_1], color="red", label="Class 1")
scatter!(x1[mask_2], x2[mask_2], color="blue", label="Class 2")
scatter!(x1[mask_3], x2[mask_3], color="yellow", label="Class 3")

xlabel!("PCA dimension 1")
ylabel!("PCA dimension 2")

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
