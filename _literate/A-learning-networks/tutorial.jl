using Pkg # hideall
Pkg.activate("_literate/A-learning-networks/Project.toml")
Pkg.update();

# ## Preliminary steps
#
# Let's generate a `DataFrame` with some dummy regression data, let's also load the good old ridge regressor.

using MLJ, StableRNGs
import DataFrames
MLJ.color_off() # hide
Ridge = @load RidgeRegressor pkg=MultivariateStats

rng = StableRNG(551234) # for reproducibility

x1 = rand(rng, 300)
x2 = rand(rng, 300)
x3 = rand(rng, 300)
y = exp.(x1 - x2 -2x3 + 0.1*rand(rng, 300))

X = DataFrames.DataFrame(x1=x1, x2=x2, x3=x3)
first(X, 3) |> pretty

# Let's also prepare the train and test split which will be useful later on.

test, train = partition(eachindex(y), 0.8);

# ## Defining a learning network
#
# In MLJ, a *learning network* is a directed acyclic graph (DAG) whose *nodes* apply trained or untrained operations such as a `predict` or `transform` (trained) or `+`, `vcat` etc. (untrained).
# Learning networks can be seen as pipelines on steroids.
#
# Let's consider the following simple DAG:
#
# ![Operation DAG](/assets/diagrams/composite1.svg)
#
# It corresponds to a fairly standard regression workflow: the data is standardized, the target is transformed using a Box-Cox transformation, a ridge regression is applied and the result is converted back by inverting the transform.
#
# **Note**: actually  this DAG is simple enough that it could also have been done with a pipeline.
#
# ### Sources and nodes
#
# In MLJ a learning network starts at **source** nodes and flows through nodes (`X` and `y`) defining operations/transformations (`W`, `z`, `ẑ`, `ŷ`).
# To define the source nodes, use the `source` function, you should specify whether it's a target:

Xs = source(X)
ys = source(y)

# To define an "trained-operation" node, you must simply create a machine wrapping a model and another node (the data) and indicate which operation should be performed (e.g. `transform`):

stand = machine(Standardizer(), Xs)
W = transform(stand, Xs)

# You can `fit!` a trained-operation node at any point, MLJ will fit whatever it needs that is upstream of that node.
# In this case, there is just a source node upstream of `W` so fitting `W` will just fit the standardizer:

fit!(W, rows=train);

# If you want to get the transformed data, you can then call the node speciying on which part of the data the operation should be performed:

W()             # transforms all data
W(rows=test, )  # transforms only test data
W(X[3:4, :])    # transforms specific data

# Let's now define the other nodes:

box_model = UnivariateBoxCoxTransformer()
box = machine(box_model, ys)
z = transform(box, ys)

ridge_model = Ridge(lambda=0.1)
ridge = machine(ridge_model, W, z)
ẑ = predict(ridge, W)

ŷ = inverse_transform(box, ẑ)

# Note that we have not yet done any training, but if we now call `fit!` on `ŷ`, it will fit all nodes upstream of `ŷ` that need to be re-trained:

fit!(ŷ, rows=train);

# Now that `ŷ` has been fitted, you can apply the full graph on test data (or any compatible data). For instance, let's get the `rms` between the ground truth and the predicted values:

rms(y[test], ŷ(rows=test))

# ### Modifying hyperparameters
#
# Hyperparameters can be accessed using the dot syntax as usual.
# Let's modify the regularisation parameter of the ridge regression:

ridge_model.lambda = 5.0;

# Since the node `ẑ` corresponds to a machine that wraps `ridge_model`, that node has effectively changed and will be retrained:

fit!(ŷ, rows=train)
rms(y[test], ŷ(rows=test))
