using Pkg # hideall
Pkg.activate("_literate/ISL-lab-6b/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

# In this tutorial, we are exploring the application of Ridge and Lasso
# regression to the Hitters R dataset.
#

# @@dropdown
# ## Getting started
# @@
# @@dropdown-content

using MLJ
import RDatasets: dataset
using PrettyPrinting
MLJ.color_off() # hide
import Distributions
const D = Distributions

LinearRegressor = @load LinearRegressor pkg=MLJLinearModels
RidgeRegressor = @load RidgeRegressor pkg=MLJLinearModels
LassoRegressor = @load LassoRegressor pkg=MLJLinearModels

# We load the dataset using the `dataset` function, which takes the Package and
# dataset names as arguments.

hitters = dataset("ISLR", "Hitters")
@show size(hitters)
names(hitters) |> pprint

# Let's unpack the dataset with the `unpack` function.
# In this case, the target is `Salary` (`==(:Salary)`) and all other columns are features (`col->true`).

y, X = unpack(hitters, ==(:Salary), col->true);

# The target has missing values which we will just ignore.
# We extract the row indices corresponding to non-missing values of the target.
# Note the use of the element-wise operator `.`.
no_miss = .!ismissing.(y);

# We collect the non missing values of the target in an Array.
# And keep only the corresponding features values.
y = collect(skipmissing(y))
X = X[no_miss, :]

# Let's now split our dataset into a train and test sets.
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=424);

# Let's have a look at the target.
using Plots

plot(y, seriestype=:scatter, markershape=:circle, legend=false, size=(800,600))

xlabel!("Index")
ylabel!("Salary")

# \figalt{Salary}{ISL-lab-6-g1.svg}

# That looks quite skewed, let's have a look at a histogram:

histogram(y, bins=50, normalize=true, label=false, size=(800,600))
xlabel!("Salary")
ylabel!("Density")

edfit = D.fit_mle(D.Exponential, y)
xx = range(minimum(y), 2500, length=100)
yy = pdf.(edfit, xx)
plot!(xx, yy, label="Exponential distribution fit", linecolor=:orange, linewidth = 4)


savefig(joinpath(@OUTPUT, "ISL-lab-6-g2.svg")) # hide

# \figalt{Distribution of salary}{ISL-lab-6-g2.svg}
#

# @@dropdown
# ### Data preparation
# @@
# @@dropdown-content
#
# Most features are currently encoded as integers but we will consider them as continuous.
# To coerce `int` features to `Float`, we nest the `autotype` function in the `coerce` function.
# The `autotype` function returns a dictionary containing scientific types, which is then passed to the `coerce` function.
# For more details on the use of `autotype`, see the [Scientific Types](https://alan-turing-institute.github.io/DataScienceTutorials.jl/data/scitype/index.html#autotype)

Xc = coerce(X, autotype(X, rules=(:discrete_to_continuous,)))
scitype(Xc)

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
#
# Let's first fit a simple pipeline with a standardizer, a one-hot-encoder and a basic linear regression:

model = Pipeline(Standardizer(), OneHotEncoder(), LinearRegressor())

pipe  = machine(model, Xc, y)
fit!(pipe, rows=train)
ŷ = MLJ.predict(pipe, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)

# Let's get a feel for how we're doing

res = ŷ .- y[test]
plot(res, line=:stem, ylims=(-1300, 1000), linewidth=3, marker=:circle, legend=false, size=((800,600)))
hline!([0], linewidth=2, color=:red)
xlabel!("Index")
ylabel!("Residual (ŷ - y)")

savefig(joinpath(@OUTPUT, "ISL-lab-6-g3.svg")) # hide

# \figalt{Residuals}{ISL-lab-6-g3.svg}

histogram(res, bins=30, normalize=true, color=:green, label=false, size=(800,600), xlims=(-1100, 1100))

xx = range(-1100, 1100, length=100)
ndfit = D.fit_mle(D.Normal, res)
lfit  = D.fit_mle(D.Laplace, res)

plot!(xx, pdf.(ndfit, xx), linecolor=:orange, label="Normal fit", linewidth = 3)
plot!(xx, pdf.(lfit, xx), linecolor=:magenta, label="Laplace fit", linewidth = 3)
xlabel!("Residual (ŷ - y)")
ylabel!("Density")

savefig(joinpath(@OUTPUT, "ISL-lab-6-g4.svg")) # hide

# \figalt{Distribution of residuals}{ISL-lab-6-g4.svg}


# ‎
# @@
# @@dropdown
# ### Basic Ridge
# @@
# @@dropdown-content
#
# Let's now swap the linear regressor for a Ridge one without specifying the penalty (`1` by default):
# We modify the supervised model in the pipeline directly.

pipe.model.linear_regressor = RidgeRegressor()
fit!(pipe, rows=train)
ŷ = MLJ.predict(pipe, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)

# Ok that's a bit better but surely we can do better with an appropriate selection of the hyperparameter.


# ‎
# @@
# @@dropdown
# ### Cross validating
# @@
# @@dropdown-content

# What penalty should you use? Let's do a simple CV to try to find out:

r  = range(model, :(linear_regressor.lambda), lower=1e-2, upper=100_000, scale=:log10)
tm = TunedModel(model=model, ranges=r, tuning=Grid(resolution=50),
                resampling=CV(nfolds=3, rng=4141), measure=rms)
mtm = machine(tm, Xc, y)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.linear_regressor.lambda, sigdigits=4)

# right, and  with that we get:

ŷ = MLJ.predict(mtm, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)

# Let's see:


res = ŷ .- y[test]
plot(res, line=:stem, xlims=(1, length(res)), ylims=(-1400, 1000), linewidth=3, marker=:circle, legend=false, size=((800,600)))
hline!([0], linewidth=2, color=:red)
xlabel!("Index")
ylabel!("Residual (ŷ - y)")


savefig(joinpath(@OUTPUT, "ISL-lab-6-g5.svg")) # hide

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
# Let's do the same as above but using a Lasso model and adjusting the range a bit:

mtm.model.model.linear_regressor = LassoRegressor()
mtm.model.range = range(model, :(linear_regressor.lambda), lower=500, upper=100_000, scale=:log10)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.linear_regressor.lambda, sigdigits=4)

# Ok and let's see how that does:

ŷ = MLJ.predict(mtm, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)

# Pretty good! and the parameters are reasonably sparse as expected:

coefs, intercept = fitted_params(mtm.fitresult).linear_regressor
@show coefs
@show intercept

# with around 50% sparsity:

coef_vals = [c[2] for c in coefs]
sum(coef_vals .≈ 0) / length(coefs)
# Let's visualise this:

## name of the features including one-hot-encoded ones
all_names = [:AtBat, :Hits, :HmRun, :Runs, :RBI, :Walks, :Years,
             :CAtBat, :CHits, :CHmRun, :CRuns, :CRBI, :CWalks,
             :League__A, :League__N, :Div_E, :Div_W,
             :PutOuts, :Assists, :Errors, :NewLeague_A, :NewLeague_N]

idxshow = collect(1:length(coef_vals))[abs.(coef_vals) .> 0]

plot(coef_vals, xticks=(idxshow, all_names), legend=false, xrotation=90, line=:stem, marker=:circle, size=((800,700)))
hline!([0], linewidth=2, color=:red)
ylabel!("Amplitude")
xlabel!("Coefficient")

savefig(joinpath(@OUTPUT, "ISL-lab-6-g6.svg")) # hide

# \figalt{Lasso coefficients}{ISL-lab-6-g6.svg}


# ‎
# @@
# @@dropdown
# ## Elastic net pipeline
# @@
# @@dropdown-content

ElasticNetRegressor = @load ElasticNetRegressor pkg=MLJLinearModels

mtm.model.model.linear_regressor = ElasticNetRegressor()
mtm.model.range = [range(model, :(linear_regressor.lambda), lower=0.1, upper=100, scale=:log10),
                    range(model, :(linear_regressor.gamma),  lower=500, upper=10_000, scale=:log10)]
mtm.model.tuning = Grid(resolution=10)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
@show round(best_mdl.linear_regressor.lambda, sigdigits=4)
@show round(best_mdl.linear_regressor.gamma, sigdigits=4)

# And it's not too bad in terms of accuracy either

ŷ = MLJ.predict(mtm, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)

# But the simple ridge regression seems to work best here.

# ‎
# @@
