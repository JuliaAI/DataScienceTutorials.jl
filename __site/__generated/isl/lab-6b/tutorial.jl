# Before running this, please make sure to activate and instantiate the
# tutorial-specific package environment, using this
# [`Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/isl/lab-6b/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/isl/lab-6b/Manifest.toml), or by following
# [these](https://juliaai.github.io/DataScienceTutorials.jl/#learning_by_doing) detailed instructions.

# regression to the Hitters R dataset.

# @@dropdown
# ## Getting started
# @@
# @@dropdown-content

using MLJ
import RDatasets: dataset
using PrettyPrinting
import Distributions as D

LinearRegressor = @load LinearRegressor pkg = MLJLinearModels
RidgeRegressor = @load RidgeRegressor pkg = MLJLinearModels
LassoRegressor = @load LassoRegressor pkg = MLJLinearModels

# We load the dataset using the `dataset` function, which takes the Package and
# dataset names as arguments.

hitters = dataset("ISLR", "Hitters")
@show size(hitters)
names(hitters) |> pprint

# Let's unpack the dataset with the `unpack` function.  In this case, the target is
# `Salary` (`==(:Salary)`); and all other columns are features, going into a table `X`.

y, X = unpack(hitters, ==(:Salary));

# The target has missing values which we will just ignore.
# We extract the row indices corresponding to non-missing values of the target.
# Note the use of the element-wise operator `.`.

no_miss = .!ismissing.(y);

# We collect the non missing values of the target in an Array.

# And keep only the corresponding features values.

y = collect(skipmissing(y))
X = X[no_miss, :];

# Let's now split our dataset into a train and test sets.
train, test = partition(eachindex(y), 0.5, shuffle = true, rng = 424);

# Let's have a look at the target.

using Plots

plot(
    y,
    seriestype = :scatter,
    markershape = :circle,
    legend = false,
    size = (800, 600),
)

xlabel!("Index")
ylabel!("Salary")

# \figalt{Salary}{ISL-lab-6-g1.svg}

# That looks quite skewed, let's have a look at a histogram:

histogram(y, bins = 50, normalize = true, label = false, size = (800, 600))
xlabel!("Salary")
ylabel!("Density")

edfit = D.fit_mle(D.Exponential, y)
xx = range(minimum(y), 2500, length = 100)
yy = pdf.(edfit, xx)
plot!(
    xx,
    yy,
    label = "Exponential distribution fit",
    linecolor = :orange,
    linewidth = 4,
)

# \figalt{Distribution of salary}{ISL-lab-6-g2.svg}

# @@dropdown
# ### Data preparation
# @@
# @@dropdown-content

# Most features are currently encoded as integers but we will consider them as continuous.
# To coerce `int` features to `Float`, we nest the `autotype` function in the `coerce`
# function.  The `autotype` function returns a dictionary containing scientific types,
# which is then passed to the `coerce` function.  For more details on the use of
# `autotype`, see the [Scientific
# Types](https://alan-turing-institute.github.io/DataScienceTutorials.jl/data/scitype/index.html#autotype)

Xc = coerce(X, autotype(X, rules = (:discrete_to_continuous,)))
schema(Xc)

# There're a few features that are categorical which we'll one-hot-encode.

# ‎
# @@

# ‎
# @@
# @@dropdown
# ## Ridge pipeline
# @@
# @@dropdown-content

# @@dropdown
# ### Baseline
# @@
# @@dropdown-content

# Let's first fit a simple pipeline with a standardizer, a one-hot-encoder and a basic
# linear regression:

model = Standardizer() |>  OneHotEncoder() |> LinearRegressor()

pipe = machine(model, Xc, y)
fit!(pipe, rows = train)
ŷ = MLJ.predict(pipe, rows = test)
round(rms(ŷ, y[test])^2, sigdigits = 4)

# Let's get a feel for how we're doing

res = ŷ .- y[test]
plot(
    res,
    line = :stem,
    ylims = (-1300, 1000),
    linewidth = 3,
    marker = :circle,
        legend = false,
    size = ((800, 600)),
)
hline!([0], linewidth = 2, color = :red)
xlabel!("Index")
ylabel!("Residual (ŷ - y)")

# \figalt{Residuals}{ISL-lab-6-g3.svg}

histogram(
    res,
    bins = 30,
    normalize = true,
    color = :green,
    label = false,
    size = (800, 600),
    xlims = (-1100, 1100),
)

xx    = range(-1100, 1100, length = 100)
ndfit = D.fit_mle(D.Normal, res)
lfit  = D.fit_mle(D.Laplace, res)

plot!(xx, pdf.(ndfit, xx), linecolor = :orange, label = "Normal fit", linewidth = 3)
plot!(xx, pdf.(lfit, xx), linecolor = :magenta, label = "Laplace fit", linewidth = 3)
xlabel!("Residual (ŷ - y)")
ylabel!("Density")

# \figalt{Distribution of residuals}{ISL-lab-6-g4.svg}

# ‎
# @@
# @@dropdown
# ### Basic Ridge
# @@
# @@dropdown-content

# Let's now swap the linear regressor for a Ridge one without specifying the penalty (`1`
# by default): We modify the supervised model in the pipeline directly.

pipe.model.linear_regressor = RidgeRegressor()
fit!(pipe, rows = train)
ŷ = MLJ.predict(pipe, rows = test)
round(rms(ŷ, y[test])^2, sigdigits = 4)

# Ok that's a bit better but perhaps we can do better with an appropriate selection of the
# hyperparameter.

# ‎
# @@
# @@dropdown
# ### Cross validating
# @@
# @@dropdown-content

# What penalty should you use? Let's do a simple CV to try to find out:

r = range(
    model,
    :(linear_regressor.lambda),
    lower = 1e-2,
    upper = 100,
    scale = :log10,
)
tm = TunedModel(
    model,
    ranges = r,
    tuning = Grid(resolution = 50),
    resampling = CV(nfolds = 3, rng = 4141),
    measure = rms,
)
mtm = machine(tm, Xc, y)
fit!(mtm, rows = train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.linear_regressor.lambda, sigdigits = 4)

# Right, and  with that we get:

ŷ = MLJ.predict(mtm, rows = test)
round(rms(ŷ, y[test])^2, sigdigits = 4)

# This is a poorer result, but that's not a complete surprise. To optimize `lambda` we've
# sacrificed some data (for the cross-validation), and we only have 263 observations
# total.

# Again visualizing the residuals:

res = ŷ .- y[test]
plot(
    res,
    line = :stem,
    xlims = (1, length(res)),
    ylims = (-1400, 1000),
    linewidth = 3,
    marker = :circle,
    legend = false,
    size = ((800, 600)),
)
hline!([0], linewidth = 2, color = :red)
xlabel!("Index")
ylabel!("Residual (ŷ - y)")

# \figalt{Ridge residuals}{ISL-lab-6-g5.svg}
#
# You can compare that with the residuals obtained earlier.

# ‎
# @@

# ‎
# @@
# @@dropdown
# ## Lasso pipeline
# @@
# @@dropdown-content
#
# Let's do the same as above but using a Lasso model (which also has a regularization
# parameter named `lambda`) but adjust the range a bit:

mtm.model.model.linear_regressor = LassoRegressor()
mtm.model.range = range(
    model,
    :(linear_regressor.lambda),
    lower = 5,
    upper = 1000,
    scale = :log10,
)
fit!(mtm, rows = train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.linear_regressor.lambda, sigdigits = 4)

# Ok and let's see how that does:

ŷ = MLJ.predict(mtm, rows = test)
round(rms(ŷ, y[test])^2, sigdigits = 4)

# A pretty similar result to the previous one. Notice the parameters are reasonably
# sparse, as expected with an L1-regularizer:

coefs, intercept = fitted_params(mtm.fitresult).linear_regressor
@show coefs
@show intercept

# with around 50% sparsity:

coef_vals = [c[2] for c in coefs]
sum(coef_vals .≈ 0) / length(coefs)

# Let's visualise this:

# name of the features including one-hot-encoded ones

all_names = [:AtBat, :Hits, :HmRun, :Runs, :RBI, :Walks, :Years,
        :CAtBat, :CHits, :CHmRun, :CRuns, :CRBI, :CWalks,
        :League__A, :League__N, :Div_E, :Div_W,
        :PutOuts, :Assists, :Errors, :NewLeague_A, :NewLeague_N]

idxshow = collect(1:length(coef_vals))[abs.(coef_vals).>0]

plot(
    coef_vals,
    xticks = (idxshow, all_names),
    legend = false,
    xrotation = 90,
    line = :stem,
    marker = :circle,
    size = ((800, 700)),
)
hline!([0], linewidth = 2, color = :red)
ylabel!("Amplitude")
xlabel!("Coefficient")

# \figalt{Lasso coefficients}{ISL-lab-6-g6.svg}

# For this baby dataset, simple ridge regression, with default hyperparameters, appears to
# work best. Of course, without a deeper analysis, we cannot say the differences observed
# are statistically significant. For this small data set, it's doubtful.

# ‎
# @@

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
