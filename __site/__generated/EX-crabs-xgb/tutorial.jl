# Before running this, please make sure to activate and instantiate the
# tutorial-specific package environment, using this
# [`Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/EX-crabs-xgb/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/EX-crabs-xgb/Manifest.toml), or by following
# [these](https://juliaai.github.io/DataScienceTutorials.jl/#learning_by_doing) detailed instructions.

# This example is inspired from [this
# post](https://www.analyticsvidhya.com/blog/2016/03/complete-guide-parameter-tuning-xgboost-with-codes-python/)
# showing how to use XGBoost.

# @@dropdown
# ## First steps
# @@
# @@dropdown-content

# MLJ provides a built-in function to load the Crabs dataset:

using MLJ
using StatsBase
using Random
using Plots
import DataFrames
import StableRNGs.StableRNG


X, y = @load_crabs # a table and a vector
X = DataFrames.DataFrame(X)
@show size(X)
@show y[1:3]
first(X, 3)

schema(X)

# We are looking at a classification problem with the following classes:

levels(y)

# It's not a very big dataset so we will likely overfit it badly using something as
# sophisticated as XGBoost but it will do for a demonstration. Since our data set is
# ordered by target class, we'll be sure to create shuffled train/test index sets:

train, test = partition(collect(eachindex(y)), 0.70, rng=StableRNG(123))
XGBC = @load XGBoostClassifier
xgb_model = XGBC()

# Let's check whether the training and is balanced, `StatsBase.countmap` is useful for
# that:

countmap(y[train])

# which is pretty balanced. You could check the same on the test set and full set and the
# same comment would still hold.

# ‎

# ‎
# @@
# @@dropdown
# ## XGBoost machine
# @@
# @@dropdown-content

# Wrap a machine around an XGBoost model (XGB) and the data:

xgb  = XGBC()
mach = machine(xgb, X, y)

# We will tune it varying the number of rounds used and generate a learning curve

r = range(xgb, :num_round, lower=50, upper=500)
curve = learning_curve(
    mach,
    range=r,
    resolution=50,
    measure=brier_loss,
)

# Let's have a look

plot(curve.parameter_values, curve.measurements)
xlabel!("Number of rounds", fontsize=14)
ylabel!("Brier loss", fontsize=14)

# \figalt{Brier loss vs Num Round}{EX-crabs-xgb-curve1.svg}
#
# Not a lot of improvement after 300 rounds.

xgb.num_round = 300;

# @@dropdown
# ### More tuning (1)
# @@
# @@dropdown-content

# Let's now tune the maximum depth of each tree and the minimum child weight in the
# boosting.

r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :min_child_weight, lower=0, upper=5)

tuned_model = TunedModel(
    xgb,
    tuning=Grid(resolution=8),
    resampling=CV(rng=11),
    ranges=[r1,r2],
    measure=brier_loss,
)
mach = machine(tuned_model, X, y)
fit!(mach, rows=train)

# Let's visualize details about the tuning:

plot(mach)

# \figalt{Hyperparameter tuningplot}{EX-crabs-xgb-tuningplot.svg}

# Let's extract the optimal model and inspect its parameters:

xgb = fitted_params(mach).best_model
@show xgb.max_depth
@show xgb.min_child_weight

# ‎

# ‎
# @@
# @@dropdown
# ### More tuning (2)
# @@
# @@dropdown-content

# Let's examine the effect of `gamma`. This time we'll use a visual approach:

mach = machine(xgb, X, y)
curve = learning_curve(
    mach,
    range= range(xgb, :gamma, lower=0, upper=10),
    resolution=30,
    measure=brier_loss,
);

plot(curve.parameter_values, curve.measurements)
xlabel!("gamma", fontsize=14)
ylabel!("Brier loss", fontsize=14)

# \figalt{Tuning gamma}{EX-crabs-xgb-gamma.svg}

# The following choice looks about optimal:

xgb.gamma = 3.8

# performance.

# ‎
# @@
# @@dropdown
# ### More tuning (3)
# @@
# @@dropdown-content

# Let's next examine the effect of `subsample` and `colsample_bytree`:

r1 = range(xgb, :subsample, lower=0.6, upper=1.0)
r2 = range(xgb, :colsample_bytree, lower=0.6, upper=1.0)

tuned_model = TunedModel(
    xgb,
    tuning=Grid(resolution=8),
    resampling=CV(rng=234),
    ranges=[r1,r2],
    measure=brier_loss,
)
mach = machine(tuned_model, X, y)
fit!(mach, rows=train)

plot(mach)

# \figalt{Hyperparameter tuningplot}{EX-crabs-xgb-tuningplot2.svg}
#
# Let's retrieve the best models:

xgb = fitted_params(mach).best_model
@show xgb.subsample
@show xgb.colsample_bytree

# We could continue with more fine tuning but given how small the dataset is, it doesn't
# make much sense.  How does it fare on the test set?

ŷ = predict_mode(mach, rows=test)
round(accuracy(ŷ, y[test]), sigdigits=3)

# Not too bad.

# ‎
# @@

# ‎
# @@

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
