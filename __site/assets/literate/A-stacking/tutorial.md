<!--This file was generated, do not modify it.-->
````julia:ex1
using Pkg # hideall
Pkg.activate("_literate/A-stacking/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;
````

An advanced illustration of learning networks.

In stacking one blends the predictions of different regressors or classifiers to gain,
in some cases, better performance than naive averaging or majority vote. The gains may
small, their statistical significance in doubt, and the approach is computationally
intensive. Nevertheless, stacking has been used successfully by teams in data science
science competitions.

For routine stacking tasks the MLJ user should use the `Stack` model documented
[here](https://alan-turing-institute.github.io/MLJ.jl/dev/composing_models/#Model-Stacking). Internally,
`Stack` is implemented using MLJ's learning networks feature, and the purpose of this
tutorial give an advanced illustration of MLJ learning networks by presenting a
simplified version of this implementation. Familiarity with model stacking is not
essential, but we assume the reader is already familiar with learning network basics, as
illustrated in the [Learning
networks](https://alan-turing-institute.github.io/MLJ.jl/dev/learning_networks/) section
of the MLJ manual. The "Ensembles (learning networks)" tutorial also gives a simple
illustration.

Specifically, we build a two-model stack, first as an MLJ learning
network, and then as an "exported" stand-alone composite model type `MyTwoStack`.

As we shall see, as a new stand-alone model type, we can apply the
usual meta-algorithms, such as performance evaluation and tuning, to
`MyTwoStack`.

@@dropdown
## Basic stacking using out-of-sample base learner predictions
@@
@@dropdown-content

A rather general stacking protocol was first described in a [1992
paper](https://www.sciencedirect.com/science/article/abs/pii/S0893608005800231)
by David Wolpert. For a generic introduction to the basic two-layer
stack described here, see [this blog
post](https://burakhimmetoglu.com/2016/12/01/stacking-models-for-improved-predictions/)
of Burak Himmetoglu.

A basic stack consists of a number of base learners (two, in this
illustration) and a single adjudicating model.

When a stacked model is called to make a prediction, the individual
predictions of the base learners are made the columns of an *input*
table for the adjudicating model, which then outputs the final
prediction. However, it is crucial to understand that the flow of
data *during training* is not the same.

The base model predictions used to train the adjudicating model are
*not* the predictions of the base learners fitted to all the
training data. Rather, to prevent the adjudicator giving too much
weight to the base learners with low *training* error, the input
data is first split into a number of folds (as in cross-validation),
a base learner is trained on each fold complement individually, and
corresponding predictions on the folds are spliced together to form
a full-length prediction called the *out-of-sample prediction*.

For illustrative purposes we use just three folds. Each base learner
will get three separate machines, for training on each fold
complement, and a fourth machine, trained on all the supplied data,
for use in the prediction flow.

We build the learning network with dummy data at the source nodes,
so the reader inspects the workings of the network as it is built (by
calling `fit!` on nodes, and by calling the nodes themselves). As
usual, this data is not seen by the exported composite model type,
and the component models we choose are just default values for the
hyperparameters of the composite model.

````julia:ex2
using MLJ
MLJ.color_off() # hide
import StableRNGs.StableRNG
````

Some models we will use:

````julia:ex3
linear = (@load LinearRegressor pkg=MLJLinearModels)()
knn = (@load KNNRegressor)()

tree_booster = (@load EvoTreeRegressor)()
forest = (@load RandomForestRegressor pkg=DecisionTree)()
svm = (@load EpsilonSVR pkg=LIBSVM)()
````

@@dropdown
### Warm-up exercise: Define a model type to average predictions
@@
@@dropdown-content

Let's define a composite model type `MyAverageTwo` that
averages the predictions of two deterministic regressors. Here's the learning network:

````julia:ex4
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
````

Let's create an instance of the new type:

````julia:ex5
average_two = MyAverageTwo(linear, knn)
````

Evaluating this average model on the Boston data set, and comparing
with the base model predictions:

````julia:ex6
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
````

‎
@@

‎
@@
@@dropdown
## Stacking proper
@@
@@dropdown-content

@@dropdown
### Helper functions:
@@
@@dropdown-content

To generate folds for generating out-of-sample predictions, we define

````julia:ex7
folds(data, nfolds) =
    partition(1:nrows(data), (1/nfolds for i in 1:(nfolds-1))...);
````

For example, we have:

````julia:ex8
f = folds(1:10, 3)
````

It will also be convenient to use the MLJ method `restrict(X, f, i)`
that restricts data `X` to the `i`th element (fold) of `f`, and
`corestrict(X, f, i)` that restricts to the corresponding fold
complement (the concatenation of all but the `i`th
fold).

For example, we have:

````julia:ex9
corestrict(string.(1:10), f, 2)
````

‎
@@
@@dropdown
### Choose some test data (optional) and some component models (defaults for the composite model):
@@
@@dropdown-content

````julia:ex10
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.2) # hide

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
````

\fig{s1.svg}

Some models to stack (which we can change later):

````julia:ex11
model1 = linear
model2 = knn
````

The adjudicating model:

````julia:ex12
judge = linear
````

‎
@@
@@dropdown
### Define the training nodes
@@
@@dropdown-content

Let's instantiate some input and target source nodes for the
learning network, wrapping the play data defined above in source
nodes:

````julia:ex13
X = source(Xraw)
y = source(yraw)
````

Our first internal node will represent the three folds (vectors of row indices) for
creating the out-of-sample predictions. We would like to define `f = folds(X, 3)` but
this will not work because `X` is not a table, just a node representing a table. So
instead we do this:

````julia:ex14
f = node(X) do x
    folds(x, 3)
end
````

Now `f` is itself a node, and so callable:

````julia:ex15
f()
````

We'll overload `restrict` and `corestrict` for nodes, to save us having to write
`node(....)` all the time:

````julia:ex16
MLJ.restrict(X::AbstractNode, f::AbstractNode, i) =  node(X, f) do XX, ff
    restrict(XX, ff, i)
end
MLJ.corestrict(X::AbstractNode, f::AbstractNode, i) = node(X, f) do XX, ff
    corestrict(XX, ff, i)
end
````

We are now ready to define machines for training `model1` on each
fold-complement:

````julia:ex17
m11 = machine(model1, corestrict(X, f, 1), corestrict(y, f, 1))
m12 = machine(model1, corestrict(X, f, 2), corestrict(y, f, 2))
m13 = machine(model1, corestrict(X, f, 3), corestrict(y, f, 3))
````

Define each out-of-sample prediction of `model1`:

````julia:ex18
y11 = predict(m11, restrict(X, f, 1));
y12 = predict(m12, restrict(X, f, 2));
y13 = predict(m13, restrict(X, f, 3));
````

Splice together the out-of-sample predictions for model1:

````julia:ex19
y1_oos = vcat(y11, y12, y13);
````

Note there is no need to overload the `vcat` function to work on
nodes; it does so out of the box, as does `hcat` and basic
arithmetic operations.

Since our source nodes are wrapping data, we can optionally check
our network so far, by calling fitting and calling `y1_oos`:

````julia:ex20
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
````

\fig{s2.svg}

We now repeat the procedure for the other model:

````julia:ex21
m21 = machine(model2, corestrict(X, f, 1), corestrict(y, f, 1))
m22 = machine(model2, corestrict(X, f, 2), corestrict(y, f, 2))
m23 = machine(model2, corestrict(X, f, 3), corestrict(y, f, 3))
y21 = predict(m21, restrict(X, f, 1));
y22 = predict(m22, restrict(X, f, 2));
y23 = predict(m23, restrict(X, f, 3));
````

And testing the knn out-of-sample prediction:

````julia:ex22
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
````

\fig{s3.svg}

Now that we have the out-of-sample base learner predictions, we are
ready to merge them into the adjudicator's input table and construct
the machine for training the adjudicator:

````julia:ex23
X_oos = MLJ.table(hcat(y1_oos, y2_oos))
m_judge = machine(judge, X_oos, y)
````

Are we done with constructing machines? Well, not quite. Recall that
when we use the stack to make predictions on new data, we will be
feeding the adjudicator ordinary predictions of the base learners
(rather than out-of-sample predictions). But so far, we have only
defined machines to train the base learners on fold complements, not
on the full data, which we do now:

````julia:ex24
m1 = machine(model1, X, y)
m2 = machine(model2, X, y)
````

‎
@@
@@dropdown
### Define nodes still needed for prediction
@@
@@dropdown-content

To obtain the final prediction, `yhat`, we get the base learner
predictions, based on training with all data, and feed them to the
adjudicator:

````julia:ex25
y1 = predict(m1, X);
y2 = predict(m2, X);
X_judge = MLJ.table(hcat(y1, y2))
yhat = predict(m_judge, X_judge)
````

Let's check the final prediction node can be fit and called:

````julia:ex26
fit!(yhat, verbosity=0)

plot(xsort, ysort, linetype=:stepmid, label="truth")
plot!(x, yhat(), seriestype=:scatter, markershape=:circle, label="yhat", xlim=(-4.5, 4.5))


savefig(joinpath(@OUTPUT, "s4.svg")); # hide
````

\fig{s4}

We note only in passing that, in this baby example at least, stacking has a worse
*training* error than naive averaging:

````julia:ex27
e1 = rms(y1(), y())
e2 = rms(y2(), y())
emean = rms(0.5*y1() + 0.5*y2(), y())
estack = rms(yhat(), y())
@show e1 e2 emean estack;
````

‎
@@

‎
@@
@@dropdown
## Export the learning network as a new model type
@@
@@dropdown-content

The learning network (less the data wrapped in the source nodes) amounts to a
specification of a new composite model type for two-model stacks, trained with
three-fold resampling of base model predictions. Let's create the new "exported" type
`MyTwoModelStack`, in the same way we exported the network for model averaging
(essentially a copy and paste exercise):

````julia:ex28
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
````

For convenience, we'll give this a keywork argument constructor:

````julia:ex29
MyTwoModelStack(; model1=linear, model2=knn, judge=linear) =
    MyTwoModelStack(model1, model2, judge)
````

And this completes the definition of our re-usable stacking model type.

‎
@@
@@dropdown
## Applying `MyTwoModelStack` to some data
@@
@@dropdown-content

Without undertaking any hyperparameter optimization, we evaluate the
performance of a tree boosting algorithm and a support vector
machine on a synthetic data set. As adjudicator, we'll use a random
forest.

We use a synthetic set to give an example where stacking is
effective but the data is not too large. (As synthetic data is based
on perturbations to linear models, we are deliberately avoiding
linear models in stacking illustration.)

````julia:ex30
X, y = make_regression(1000, 20; sparse=0.75, noise=0.1, rng=StableRNG(1));
````

#### Define the stack and compare performance

````julia:ex31
avg = MyAverageTwo(tree_booster,svm)
stack = MyTwoModelStack(model1=tree_booster, model2=svm, judge=forest)
all_models = [tree_booster, svm, forest, avg, stack];

for model in all_models
    print_performance(model, X, y)
end
````

#### Tuning a stack

A standard abuse of good data hygiene is to optimize stack component
models *separately* and then tune the adjudicating model
hyperparameters (using the same resampling of the data) with the
base learners fixed. Although more computationally expensive, better
generalization might be expected by applying tuning to the stack as
a whole, either simultaneously, or in cheaper sequential
steps. Since our stack is a stand-alone model, this is readily
implemented.

As a proof of concept, let's see how to tune one of the base model
hyperparameters, based on performance of the stack as a whole:

````julia:ex32
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
````

Let's evaluate the best stack using the same data resampling used to
evaluate the various untuned models earlier (now we are neglecting
data hygiene!):

````julia:ex33
print_performance(best_stack, X, y)
````

‎
@@

