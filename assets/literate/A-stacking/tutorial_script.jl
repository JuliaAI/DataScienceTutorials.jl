# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/A-stacking/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
MLJ.color_off() # hide
import StableRNGs.StableRNG

linear = (@load LinearRegressor pkg=MLJLinearModels)()
knn = (@load KNNRegressor)()

tree_booster = (@load EvoTreeRegressor)()
forest = (@load RandomForestRegressor pkg=DecisionTree)()
svm = (@load EpsilonSVR pkg=LIBSVM)()

mutable struct MyAverageTwo <: DeterministicNetworkComposite
    regressor1
    regressor2
end

import MLJ.MLJBase.prefit
function prefit(::MyAverageTwo, verbosity, X, y)

    Xs = source(X)
    ys = source(y)

    m1 = machine(:regressor1, Xs, ys)
    y1 = predict(m1, Xs)

    m2 = machine(:regressor2, Xs, ys)
    y2 = predict(m2, Xs)

    yhat = 0.5*y1 + 0.5*y2

    return (predict=yhat,)
end

average_two = MyAverageTwo(linear, knn)

function print_performance(model, data...)
    e = evaluate(model, data...;
                 resampling=CV(rng=StableRNG(1234), nfolds=8),
                 measure=rms,
                 verbosity=0)
    μ = round(e.measurement[1], sigdigits=5)
    ste = round(std(e.per_fold[1])/sqrt(8), digits=5)
    println("$(MLJ.name(model)) = $μ ± $(2*ste)")
end;

X, y = @load_boston

print_performance(linear, X, y)
print_performance(knn, X, y)
print_performance(average_two, X, y)

folds(data, nfolds) =
    partition(1:nrows(data), (1/nfolds for i in 1:(nfolds-1))...);

f = folds(1:10, 3)

corestrict(string.(1:10), f, 2)

using Plots
Plots.scalefontsizes() #hide
Plots.scalefontsizes(1.2) #hide

steps(x) = x < -3/2 ? -1 : (x < 3/2 ? 0 : 1)
x = Float64[-4, -1, 2, -3, 0, 3, -2, 1, 4]
Xraw = (x = x, )
yraw = steps.(x);
idxsort = sortperm(x)
xsort = x[idxsort]
ysort = yraw[idxsort]
plot(xsort, ysort, linetype=:stepmid, label="truth")
plot!(x, yraw, seriestype=:scatter, markershape=:circle, label="data", xlim=(-4.5, 4.5))

savefig(joinpath(@OUTPUT, "s1.svg")); # hide

model1 = linear
model2 = knn

judge = linear

X = source(Xraw)
y = source(yraw)

f = node(X) do x
    folds(x, 3)
end

f()

MLJ.restrict(X::AbstractNode, f::AbstractNode, i) =  node(X, f) do XX, ff
    restrict(XX, ff, i)
end
MLJ.corestrict(X::AbstractNode, f::AbstractNode, i) = node(X, f) do XX, ff
    corestrict(XX, ff, i)
end

m11 = machine(model1, corestrict(X, f, 1), corestrict(y, f, 1))
m12 = machine(model1, corestrict(X, f, 2), corestrict(y, f, 2))
m13 = machine(model1, corestrict(X, f, 3), corestrict(y, f, 3))

y11 = predict(m11, restrict(X, f, 1));
y12 = predict(m12, restrict(X, f, 2));
y13 = predict(m13, restrict(X, f, 3));

y1_oos = vcat(y11, y12, y13);

fit!(y1_oos, verbosity=0)

plot(xsort, ysort, linetype=:stepmid, label="truth")
plot!(
    x,
    y1_oos(),
    seriestype=:scatter,
    markershape=:circle,
    label="linear oos",
    xlim=(-4.5, 4.5),
)

savefig(joinpath(@OUTPUT, "s2.svg")); # hide

m21 = machine(model2, corestrict(X, f, 1), corestrict(y, f, 1))
m22 = machine(model2, corestrict(X, f, 2), corestrict(y, f, 2))
m23 = machine(model2, corestrict(X, f, 3), corestrict(y, f, 3))
y21 = predict(m21, restrict(X, f, 1));
y22 = predict(m22, restrict(X, f, 2));
y23 = predict(m23, restrict(X, f, 3));

y2_oos = vcat(y21, y22, y23);
fit!(y2_oos, verbosity=0)

plot(xsort, ysort, linetype=:stepmid, label="truth")
plot!(
    x,
    y2_oos(),
    seriestype=:scatter,
    markershape=:circle,
    label="knn oos",
    xlim=(-4.5, 4.5),
)


savefig(joinpath(@OUTPUT, "s3.svg")); # hide

X_oos = MLJ.table(hcat(y1_oos, y2_oos))
m_judge = machine(judge, X_oos, y)

m1 = machine(model1, X, y)
m2 = machine(model2, X, y)

y1 = predict(m1, X);
y2 = predict(m2, X);
X_judge = MLJ.table(hcat(y1, y2))
yhat = predict(m_judge, X_judge)

fit!(yhat, verbosity=0)

plot(xsort, ysort, linetype=:stepmid, label="truth")
plot!(x, yhat(), seriestype=:scatter, markershape=:circle, label="yhat", xlim=(-4.5, 4.5))


savefig(joinpath(@OUTPUT, "s4.svg")); # hide

e1 = rms(y1(), y())
e2 = rms(y2(), y())
emean = rms(0.5*y1() + 0.5*y2(), y())
estack = rms(yhat(), y())
@show e1 e2 emean estack;

mutable struct MyTwoModelStack <: DeterministicNetworkComposite
    model1
    model2
    judge
end

function prefit(::MyTwoModelStack, verbosity, X, y)

    Xs = source(X)
    ys = source(y)

    f = node(Xs) do x
        folds(x, 3)
    end

    m11 = machine(:model1, corestrict(Xs, f, 1), corestrict(ys, f, 1))
    m12 = machine(:model1, corestrict(Xs, f, 2), corestrict(ys, f, 2))
    m13 = machine(:model1, corestrict(Xs, f, 3), corestrict(ys, f, 3))

    y11 = predict(m11, restrict(Xs, f, 1));
    y12 = predict(m12, restrict(Xs, f, 2));
    y13 = predict(m13, restrict(Xs, f, 3));

    y1_oos = vcat(y11, y12, y13);

    m21 = machine(:model2, corestrict(Xs, f, 1), corestrict(ys, f, 1))
    m22 = machine(:model2, corestrict(Xs, f, 2), corestrict(ys, f, 2))
    m23 = machine(:model2, corestrict(Xs, f, 3), corestrict(ys, f, 3))
    y21 = predict(m21, restrict(Xs, f, 1));
    y22 = predict(m22, restrict(Xs, f, 2));
    y23 = predict(m23, restrict(Xs, f, 3));

    y2_oos = vcat(y21, y22, y23);

    X_oos = MLJ.table(hcat(y1_oos, y2_oos))
    m_judge = machine(:judge, X_oos, ys)

    m1 = machine(:model1, Xs, ys)
    m2 = machine(:model2, Xs, ys)

    y1 = predict(m1, Xs);
    y2 = predict(m2, Xs);
    X_judge = MLJ.table(hcat(y1, y2))
    yhat = predict(m_judge, X_judge)

    return (predict=yhat,)
end

MyTwoModelStack(; model1=linear, model2=knn, judge=linear) =
    MyTwoModelStack(model1, model2, judge)

X, y = make_regression(1000, 20; sparse=0.75, noise=0.1, rng=StableRNG(1));

avg = MyAverageTwo(tree_booster,svm)
stack = MyTwoModelStack(model1=tree_booster, model2=svm, judge=forest)
all_models = [tree_booster, svm, forest, avg, stack];

for model in all_models
    print_performance(model, X, y)
end

r = range(stack, :(model2.cost), lower = 0.01, upper = 10, scale=:log)
tuned_stack = TunedModel(
    model=stack,
    ranges=r,
    tuning=Grid(shuffle=false),
    measure=rms,
    resampling=Holdout(),
)

mach = fit!(machine(tuned_stack,  X, y), verbosity=0)
best_stack = fitted_params(mach).best_model
best_stack.model2.cost

print_performance(best_stack, X, y)
