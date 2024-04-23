# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/isl/lab-6b/Project.toml")
Pkg.instantiate()
macro OUTPUT()
        return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

# In this tutorial, we are exploring the application of Ridge and Lasso

using MLJ
import RDatasets: dataset
using PrettyPrinting
MLJ.color_off() # hide
import Distributions as D

LinearRegressor = @load LinearRegressor pkg = MLJLinearModels
RidgeRegressor = @load RidgeRegressor pkg = MLJLinearModels
LassoRegressor = @load LassoRegressor pkg = MLJLinearModels

hitters = dataset("ISLR", "Hitters")
@show size(hitters)
names(hitters) |> pprint

y, X = unpack(hitters, ==(:Salary));

no_miss = .!ismissing.(y);

# And keep only the corresponding features values.

y = collect(skipmissing(y))
X = X[no_miss, :];

# Let's now split our dataset into a train and test sets.
train, test = partition(eachindex(y), 0.5, shuffle = true, rng = 424);

using Plots
Plots.scalefontsizes() #hide
Plots.scalefontsizes(1.2) #hide

plot(
    y,
    seriestype = :scatter,
    markershape = :circle,
    legend = false,
    size = (800, 600),
)

xlabel!("Index")
ylabel!("Salary")

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

savefig(joinpath(@OUTPUT, "ISL-lab-6-g2.svg")); # hide

Xc = coerce(X, autotype(X, rules = (:discrete_to_continuous,)))
schema(Xc)

model = Standardizer() |>  OneHotEncoder() |> LinearRegressor()

pipe = machine(model, Xc, y)
fit!(pipe, rows = train)
ŷ = MLJ.predict(pipe, rows = test)
round(rms(ŷ, y[test])^2, sigdigits = 4)

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

savefig(joinpath(@OUTPUT, "ISL-lab-6-g3.svg")); # hide

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

savefig(joinpath(@OUTPUT, "ISL-lab-6-g4.svg")); # hide

pipe.model.linear_regressor = RidgeRegressor()
fit!(pipe, rows = train)
ŷ = MLJ.predict(pipe, rows = test)
round(rms(ŷ, y[test])^2, sigdigits = 4)

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

ŷ = MLJ.predict(mtm, rows = test)
round(rms(ŷ, y[test])^2, sigdigits = 4)

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


savefig(joinpath(@OUTPUT, "ISL-lab-6-g5.svg")); # hide

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

ŷ = MLJ.predict(mtm, rows = test)
round(rms(ŷ, y[test])^2, sigdigits = 4)

coefs, intercept = fitted_params(mtm.fitresult).linear_regressor
@show coefs
@show intercept

coef_vals = [c[2] for c in coefs]
sum(coef_vals .≈ 0) / length(coefs)

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

savefig(joinpath(@OUTPUT, "ISL-lab-6-g6.svg")); # hide
