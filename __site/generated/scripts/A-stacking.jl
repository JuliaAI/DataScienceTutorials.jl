# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# In stacking one blends the predictions of different regressors or# classifiers to gain, in some cases, better performance than naive# averaging or majority vote.
# Here we illustrate how to build a two-model stack as an MLJ learning# network, which we export as a new stand-alone composite model# type `MyTwoStack`. This will make the stack that we build completely# re-usable (new data, new models). This means we can apply# meta-algorithms, such as performance evaluation and tuning, to the# stack, exactly as we would for any other model.
# Our main purpose here is to demonstrate the flexibility of MLJ's# composite model interface. Eventually, MLJ will provide built-in# composite types or macros to achieve the same results in a few# lines, which will suffice for routine stacking tasks.
# ## Basic stacking using out-of-sample base learner predictions
# A rather general stacking protocol was first described in a [1992# paper](https://www.sciencedirect.com/science/article/abs/pii/S0893608005800231)# by David Wolpert. For a generic introduction to the basic two-layer# stack described here, see [this blog# post](https://burakhimmetoglu.com/2016/12/01/stacking-models-for-improved-predictions/)# of Burak Himmetoglu.
# A basic stack consists of a number of base learners (two, in this# illustration) and a single adjudicating model.
# When a stacked model is called to make a prediction, the individual# predictions of the base learners are made the columns of an *input*# table for the adjudicating model, which then outputs the final# prediction. However, it is crucial to understand that the flow of# data *during training* is not the same.
# The base model predictions used to train the adjudicating model are# *not* the predictions of the base learners fitted to all the# training data. Rather, to prevent the adjudicator giving too much# weight to the base learners with low *training* error, the input# data is first split into a number of folds (as in cross-validation),# a base learner is trained on each fold complement individually, and# corresponding predictions on the folds are spliced together to form# a full-length prediction called the *out-of-sample prediction*.
# For illustrative purposes we use just three folds. Each base learner# will get three separate machines, for training on each fold# complement, and a fourth machine, trained on all the supplied data,# for use in the prediction flow.
# We build the learning network with dummy data at the source nodes,# so the reader inspects the workings of the network as it is built (by# calling `fit!` on nodes, and by calling the nodes themselves). As# usual, this data is not seen by the exported composite model type,# and the component models we choose are just default values for the# hyperparameters of the composite model.
using MLJ
using PyPlot


using StableRNGs

# Some models we will use:
linear = @load LinearRegressor pkg=MLJLinearModels
knn = @load KNNRegressor; knn.K = 4
tree_booster = @load EvoTreeRegressor; tree_booster.nrounds = 100
forest = @load RandomForestRegressor pkg=DecisionTree; forest.n_trees = 500
svm = @load SVMRegressor;

# ### Warm-up exercise: Define a model type to average predictions
# Let's define a composite model type `MyAverageTwo` that# averages the predictions of two deterministic regressors. Here's the learning network:
X = source()
y = source()

model1 = linear
model2 = knn

m1 = machine(model1, X, y)
y1 = predict(m1, X)

m2 = machine(model2, X, y)
y2 = predict(m2, X)

yhat = 0.5*y1 + 0.5*y2

# In preparation for export, we wrap the learning network in a# learning network machine, which specifies what the source nodes are,# and which node is for prediction. As our exported model will make# point-predictions (as opposed to probabilistic ones), we use a# `Deterministic` ["surrogate" model](https://alan-turing-institute.github.io/MLJ.jl/dev/performance_measures/):
mach = machine(Deterministic(), X, y; predict=yhat)

# Note that we cannot actually fit this machine because we chose not# to wrap our source nodes `X` and `y` in data.
# Here's the macro call that "exports" the learning network as a new# composite model `MyAverageTwo`:
@from_network mach begin
    mutable struct MyAverageTwo
        regressor1=model1
        regressor2=model2
    end
end

# Note that, unlike a normal struct definition, the defaults `model1`# and `model2` must be specified, and they must refer to model# instances in the learning network.
# We can now create an instance of the new type:
average_two = MyAverageTwo()

# Evaluating this average model on the Boston data set, and comparing# with the base model predictions:
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
print_performance(average_two, X, y)

# ## Stacking proper# ### Helper functions:
# To generate folds for generating out-of-sample predictions, we define
folds(data, nfolds) =
    partition(1:nrows(data), (1/nfolds for i in 1:(nfolds-1))...);

# For example, we have:
f = folds(1:10, 3)

# It will also be convenient to use the MLJ method `restrict(X, f, i)`# that restricts data `X` to the `i`th element (fold) of `f`, and# `corestrict(X, f, i)` that restricts to the corresponding fold# complement (the concatenation of all but the `i`th# fold).
# For example, we have:
corestrict(string.(1:10), f, 2)

# ### Choose some test data (optional) and some component models (defaults for the composite model):
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



# \fig{s1.svg}
# Some models to stack (which we can change later):
model1 = linear
model2 = knn

# The adjudicating model:
judge = linear

# ### Define the training nodes
# Let's instantiate some input and target source nodes for the# learning network, wrapping the play data defined above in source# nodes:
X = source(Xraw)
y = source(yraw)

# Our first internal node will represent the three folds (vectors of row# indices) for creating the out-of-sample predictions. We would like# to define `f = folds(X, 3)` but this will not work because `X` is# not a table, just a node representing a table. We could fix this# by using the @node macro:
f = @node folds(X, 3)

# Now `f` is itself a node, and so callable:
f()

# However, we can also just overload `folds` to work on nodes, using the# `node` *function*:
folds(X::AbstractNode, nfolds) = node(XX->folds(XX, nfolds), X)
f = folds(X, 3)
f()

# In the case of `restrict` and `corestrict`, which also don't# operate on nodes, method overloading will save us writing `@node`# all the time:
MLJ.restrict(X::AbstractNode, f::AbstractNode, i) =
    node((XX, ff) -> restrict(XX, ff, i), X, f);
MLJ.corestrict(X::AbstractNode, f::AbstractNode, i) =
    node((XX, ff) -> corestrict(XX, ff, i), X, f);

# We are now ready to define machines for training `model1` on each# fold-complement:
m11 = machine(model1, corestrict(X, f, 1), corestrict(y, f, 1))
m12 = machine(model1, corestrict(X, f, 2), corestrict(y, f, 2))
m13 = machine(model1, corestrict(X, f, 3), corestrict(y, f, 3))

# Define each out-of-sample prediction of `model1`:
y11 = predict(m11, restrict(X, f, 1));
y12 = predict(m12, restrict(X, f, 2));
y13 = predict(m13, restrict(X, f, 3));

# Splice together the out-of-sample predictions for model1:
y1_oos = vcat(y11, y12, y13);

# Note there is no need to overload the `vcat` function to work on# nodes; it does so out of the box, as does `hcat` and basic# arithmetic operations.
# Since our source nodes are wrapping data, we can optionally check# our network so far, by calling fitting and calling `y1_oos`:
fit!(y1_oos, verbosity=0)

figure(figsize=(8,6))
step(xsort, ysort, label="truth", where="mid")
plot(x, y1_oos(), ls="none", marker="o", label="linear oos")
legend()



# \fig{s2.svg}
# We now repeat the procedure for the other model:
m21 = machine(model2, corestrict(X, f, 1), corestrict(y, f, 1))
m22 = machine(model2, corestrict(X, f, 2), corestrict(y, f, 2))
m23 = machine(model2, corestrict(X, f, 3), corestrict(y, f, 3))
y21 = predict(m21, restrict(X, f, 1));
y22 = predict(m22, restrict(X, f, 2));
y23 = predict(m23, restrict(X, f, 3));

# And testing the knn out-of-sample prediction:
y2_oos = vcat(y21, y22, y23);
fit!(y2_oos, verbosity=0)

figure(figsize=(8,6))
step(xsort, ysort, label="truth", where="mid")
plot(x, y2_oos(), ls="none", marker="o", label="knn oos")
legend()



# \fig{s3.svg}
# Now that we have the out-of-sample base learner predictions, we are# ready to merge them into the adjudicator's input table and construct# the machine for training the adjudicator:
X_oos = MLJ.table(hcat(y1_oos, y2_oos))
m_judge = machine(judge, X_oos, y)

# Are we done with constructing machines? Well, not quite. Recall that# when we use the stack to make predictions on new data, we will be# feeding the adjudicator ordinary predictions of the base learners# (rather than out-of-sample predictions). But so far, we have only# defined machines to train the base learners on fold complements, not# on the full data, which we do now:
m1 = machine(model1, X, y)
m2 = machine(model2, X, y)

# ### Define nodes still needed for prediction
# To obtain the final prediction, `yhat`, we get the base learner# predictions, based on training with all data, and feed them to the# adjudicator:
y1 = predict(m1, X);
y2 = predict(m2, X);
X_judge = MLJ.table(hcat(y1, y2))
yhat = predict(m_judge, X_judge)

# Let's check the final prediction node can be fit and called:
fit!(yhat, verbosity=0)

figure(figsize=(8,6))
step(xsort, ysort, label="truth", where="mid")
plot(x, yhat(), ls="none", marker="o", label="yhat")
legend()



# \fig{s4}
# Although of little statistical significance here, we note that# stacking gives a lower *training* error than naive averaging:
e1 = rms(y1(), y())
e2 = rms(y2(), y())
emean = rms(0.5*y1() + 0.5*y2(), y())
estack = rms(yhat(), y())
@show e1 e2 emean estack;

# ## Export the learning network as a new model type
# The learning network (less the data wrapped in the source nodes)# amounts to a specification of a new composite model type for# two-model stacks, trained with three-fold resampling of base model# predictions. Let's create the new type `MyTwoModelStack`, in the# same way we exported the network for model averaging:
@from_network machine(Deterministic(), X, y; predict=yhat) begin
    mutable struct MyTwoModelStack
        regressor1=model1
        regressor2=model2
        judge=judge
    end
end

my_two_model_stack = MyTwoModelStack()

# And this completes the definition of our re-usable stacking model type.
# ## Applying `MyTwoModelStack` to some data
# Without undertaking any hyperparameter optimization, we evaluate the# performance of a tree boosting algorithm and a support vector# machine on a synthetic data set. As adjudicator, we'll use a random# forest.
# We use a synthetic set to give an example where stacking is# effective but the data is not too large. (As synthetic data is based# on perturbations to linear models, we are deliberately avoiding# linear models in stacking illustration.)
X, y = make_regression(1000, 20; sparse=0.75, noise=0.1, rng=123);

# #### Define the stack and compare performance
avg = MyAverageTwo(regressor1=tree_booster,
                   regressor2=svm)


stack = MyTwoModelStack(regressor1=tree_booster,
                        regressor2=svm,
                        judge=forest) # judge=linear

all_models = [tree_booster, svm, forest, avg, stack];

for model in all_models
    print_performance(model, X, y)
end

# #### Tuning a stack
# A standard abuse of good data hygiene is to optimize stack component# models *separately* and then tune the adjudicating model# hyperparameters (using the same resampling of the data) with the# base learners fixed. Although more computationally expensive, better# generalization might be expected by applying tuning to the stack as# a whole, either simultaneously, or in in cheaper sequential# steps. Since our stack is a stand-alone model, this is readily# implemented.
# As a proof of concept, let's see how to tune one of the base model# hyperparameters, based on performance of the stack as a whole:
r = range(stack, :(regressor2.C), lower = 0.01, upper = 10, scale=:log)
tuned_stack = TunedModel(model=stack,
                         ranges=r,
                         tuning=Grid(shuffle=false),
                         measure=rms,
                         resampling=Holdout())

mach = fit!(machine(tuned_stack,  X, y), verbosity=0)
best_stack = fitted_params(mach).best_model
best_stack.regressor2.C

# Let's evaluate the best stack using the same data resampling used to# the evaluate the various untuned models earlier (now we are neglecting# data hygiene!):
print_performance(best_stack, X, y)



# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

