# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using HTTP, CSV, MLJ, StatsBase, PyPlot
req = HTTP.get("https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data")
data = CSV.read(req.body,
                header=["Class", "Alcool", "Malic acid", "Ash",
                        "Alcalinity of ash", "Magnesium", "Total phenols",
                        "Flavanoids", "Nonflavanoid phenols", "Proanthcyanins",
                        "Color intensity", "Hue", "OD280/OD315 of diluted wines",
                        "Proline"])
# the target is the Class column, everything else is a feature
y, X = unpack(data, ==(:Class), colname->true);

scitype_union(y)

yc = coerce(y, OrderedFactor);

for col in names(X)
    println(rpad(col, 30), scitype_union(X[:, col]))
end

X[1:5, :Proline]

Xc = coerce(X, :Proline=>Continuous, :Magnesium=>Continuous);

for col in names(Xc)
    x = Xc[:, col]
    μ = round(mean(x), sigdigits=2)
    σ = round(std(x), sigdigits=2)
    println(rpad(col, 30), lpad(μ, 5), "; " , lpad(σ, 5))
end

@load KNNClassifier pkg="NearestNeighbors"
@load MultinomialClassifier pkg="MLJLinearModels";

stand = machine(Standardizer(), Xc)
fit!(stand)
Xcs = transform(stand, Xc);

train, test = partition(eachindex(yc), 0.8, shuffle=true, rng=111);
Xtrain = selectrows(Xcs, train)
Xtest = selectrows(Xcs, test)
ytrain = selectrows(yc, train)
ytest = selectrows(yc, test);

knn = machine(KNNClassifier(), Xtrain, ytrain)
opts = (resampling=Holdout(fraction_train=0.9), measure=cross_entropy)
res = evaluate!(knn; opts...)
round(res.measurement[1], sigdigits=3)

mc = machine(MultinomialClassifier(), Xtrain, ytrain)
res = evaluate!(mc; opts...)
round(res.measurement[1], sigdigits=3)

mcr_k = misclassification_rate(predict_mode(knn, Xtrain), ytrain)
mcr_m = misclassification_rate(predict_mode(mc, Xtrain), ytrain)
println(rpad("KNN mcr:", 10), round(mcr_k, sigdigits=3))
println(rpad("MNC mcr:", 10), round(mcr_m, sigdigits=3))

@load PCA
pca = machine(PCA(maxoutdim=2), Xtrain)
fit!(pca)
Wtrain = transform(pca, Xtrain);

x1 = Wtrain.x1
x2 = Wtrain.x2

mask_1 = ytrain .== 1
mask_2 = ytrain .== 2
mask_3 = ytrain .== 3

figure(figsize=(8, 6))
plot(x1[mask_1], x2[mask_1], linestyle="none", marker="o", color="red")
plot(x1[mask_2], x2[mask_2], linestyle="none", marker="o", color="blue")
plot(x1[mask_3], x2[mask_3], linestyle="none", marker="o", color="magenta")

xlabel("PCA dimension 1", fontsize=14)
ylabel("PCA dimension 2", fontsize=14)
legend(["Class 1", "Class 2", "Class 3"], fontsize=12)
xticks(fontsize=12)
yticks(fontsize=12)



perf_k = misclassification_rate(predict_mode(knn, Xtest), ytest)
perf_m = misclassification_rate(predict_mode(mc, Xtest), ytest)
println(rpad("KNN mcr:", 10), round(perf_k, sigdigits=3))
println(rpad("MNC mcr:", 10), round(perf_m, sigdigits=3))

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

