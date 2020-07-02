# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using MLJ
using PyPlot

using StableRNGs

linear = @load LinearRegressor pkg=MLJLinearModels

ridge = @load RidgeRegressor pkg=MultivariateStats
ridge.lambda = 0.01

knn = @load KNNRegressor; knn.K = 4

tree = @load DecisionTreeRegressor; min_samples_leaf=1
forest = @load RandomForestRegressor pkg=DecisionTree
forest.n_trees=500

svm = @load SVMRegressor;

X = source()
y = source(kind=:target)

model1 = linear
model2 = knn

m1 = machine(model1, X, y)
y1 = predict(m1, X)

m2 = machine(model2, X, y)
y2 = predict(m2, X)

yhat = 0.5*y1 + 0.5*y2

avg = @from_network MyAverageTwo(regressor1=model1,
                                 regressor2=model2) <= yhat

function print_performance(model, data...)
    e = evaluate(model, data...;
                 resampling=CV(rng=StableRNG(1234), nfolds=8),
                 measure=rms,
                 verbosity=0)
    μ = round(e.measurement[1], sigdigits=5)
    ste = round(std(e.per_fold[1])/sqrt(8), digits=5)
    println("$model = $μ ± $(2*ste)")
end;

X, y = @load_boston

print_performance(linear, X, y)
print_performance(knn, X, y)
print_performance(avg, X, y)

folds(data, nfolds) =
    partition(1:nrows(data), (1/nfolds for i in 1:(nfolds-1))...);

f = folds(1:10, 3)

folds(X::AbstractNode, nfolds) = node(XX -> folds(XX, nfolds), X);

corestrict(string.(1:10), f, 2)

MLJ.restrict(X::AbstractNode, f::AbstractNode, i) =
    node((XX, ff) -> restrict(XX, ff, i), X, f);
MLJ.corestrict(X::AbstractNode, f::AbstractNode, i) =
    node((XX, ff) -> corestrict(XX, ff, i), X, f);

figure(figsize=(8,6))
steps(x) = x < -3/2 ? -1 : (x < 3/2 ? 0 : 1)
x = Float64[-4, -1, 2, -3, 0, 3, -2, 1, 4]
Xraw = (x = x, )
yraw = steps.(x);
idxsort = sortperm(x)
xsort = x[idxsort]
ysort = yraw[idxsort]
step(xsort, ysort, label="truth", where="mid")
plot(x, yraw, ls="none", marker="o", label="data")
xlim(-4.5, 4.5)
legend()



model1 = linear
model2 = knn

judge = linear

X = source(Xraw)
y = source(yraw; kind=:target)

f = folds(X, 3)
f()

m11 = machine(model1, corestrict(X, f, 1), corestrict(y, f, 1))
m12 = machine(model1, corestrict(X, f, 2), corestrict(y, f, 2))
m13 = machine(model1, corestrict(X, f, 3), corestrict(y, f, 3))

y11 = predict(m11, restrict(X, f, 1));
y12 = predict(m12, restrict(X, f, 2));
y13 = predict(m13, restrict(X, f, 3));

y1_oos = vcat(y11, y12, y13);

fit!(y1_oos, verbosity=0)

figure(figsize=(8,6))
step(xsort, ysort, label="truth", where="mid")
plot(x, y1_oos(), ls="none", marker="o", label="linear oos")
legend()



m21 = machine(model2, corestrict(X, f, 1), corestrict(y, f, 1))
m22 = machine(model2, corestrict(X, f, 2), corestrict(y, f, 2))
m23 = machine(model2, corestrict(X, f, 3), corestrict(y, f, 3))
y21 = predict(m21, restrict(X, f, 1));
y22 = predict(m22, restrict(X, f, 2));
y23 = predict(m23, restrict(X, f, 3));

y2_oos = vcat(y21, y22, y23);
fit!(y2_oos, verbosity=0)

figure(figsize=(8,6))
step(xsort, ysort, label="truth", where="mid")
plot(x, y2_oos(), ls="none", marker="o", label="knn oos")
legend()



X_oos = MLJ.table(hcat(y1_oos, y2_oos))
m_judge = machine(judge, X_oos, y)

m1 = machine(model1, X, y)
m2 = machine(model2, X, y)

y1 = predict(m1, X);
y2 = predict(m2, X);
X_judge = MLJ.table(hcat(y1, y2))
yhat = predict(m_judge, X_judge)

fit!(yhat, verbosity=0)

figure(figsize=(8,6))
step(xsort, ysort, label="truth", where="mid")
plot(x, yhat(), ls="none", marker="o", label="yhat")
legend()



e1 = rms(y1(), y())
e2 = rms(y2(), y())
emean = rms(0.5*y1() + 0.5*y2(), y())
estack = rms(yhat(), y())
@show e1 e2 emean estack;

@from_network MyTwoModelStack(regressor1=model1,
                              regressor2=model2,
                              judge=judge) <= yhat

X0, y0 = @load_reduced_ames;

s = schema(X0)
(names=collect(s.names), scitypes=collect(s.scitypes)) |> pretty

X1 = coerce(X0, :OverallQual => Continuous,
            :GarageCars => Continuous,
            :YearRemodAdd => Continuous,
            :YearBuilt => Continuous);

hot_mach = fit!(machine(OneHotEncoder(), X1), verbosity=0)
X = transform(hot_mach, X1);

scitype(X)

y1 = log.(y0)
y = transform(fit!(machine(UnivariateStandardizer(), y1),
                   verbosity=0), y1);

avg = MyAverageTwo(regressor1=forest,
                   regressor2=ridge)


stack = MyTwoModelStack(regressor1=forest,
                        regressor2=ridge,
                        judge=linear)

all_models = [forest, ridge, avg, stack];

for model in all_models
    print_performance(model, X, y)
end;

r = range(stack, :(regressor2.lambda), lower = 1, upper = 20, scale=:log)
tuned_stack = TunedModel(model=stack,
                         ranges=r,
                         tuning=Grid(),
                         measure=rms,
                         resampling=Holdout())

mach = fit!(machine(tuned_stack,  X, y), verbosity=0)
best_stack = fitted_params(mach).best_model
best_stack.regressor2.lambda

print_performance(best_stack, X, y)



# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

