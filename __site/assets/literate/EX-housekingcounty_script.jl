# This file was generated, do not modify it.

using MLJ
using PrettyPrinting
import DataFrames: DataFrame, select!, Not, describe
import Statistics
using Dates
using PyPlot
ioff() # hide
using UrlDownload

MLJ.color_off() # hide

df = DataFrame(urldownload("https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data/kc_housing.csv", true))
describe(df)

select!(df, Not([:id, :date]))
schema(df)

coerce!(df, :zipcode => Multiclass)
df.isrenovated  = @. !iszero(df.yr_renovated)
df.has_basement = @. !iszero(df.sqft_basement)
schema(df)

coerce!(df, :isrenovated => OrderedFactor, :has_basement => OrderedFactor);

unique(df.waterfront)

df.waterfront = (df.waterfront .!= "FALSE")
coerce!(df, :waterfront => OrderedFactor);

coerce!(df, autotype(df, :few_to_finite))
schema(df)

df.price = df.price ./ 1000;

select!(df, Not([:yr_renovated, :sqft_basement, :zipcode]));

plt.figure(figsize=(8,6))
plt.hist(df.price, color = "blue", edgecolor = "white", bins=50,
         density=true, alpha=0.5)
plt.xlabel("Price", fontsize=14)
plt.ylabel("Frequency", fontsize=14)
plt.savefig(joinpath(@OUTPUT, "hist_price.svg")) # hide

plt.figure(figsize=(8,6))
plt.hist(df.price[df.isrenovated .== true], color="blue", density=true,
        edgecolor="white", bins=50, label="renovated", alpha=0.5)
plt.hist(df.price[df.isrenovated .== false], color="red", density=true,
        edgecolor="white", bins=50, label="unrenovated", alpha=0.5)
plt.xlabel("Price", fontsize=14)
plt.ylabel("Frequency", fontsize=14)
plt.legend(fontsize=12)
plt.savefig(joinpath(@OUTPUT, "hist_price2.svg")) # hide

@load DecisionTreeRegressor

y, X = unpack(df, ==(:price), col -> true)
train, test = partition(eachindex(y), 0.7, shuffle=true, rng=5)

tree = machine(DecisionTreeRegressor(), X, y)

fit!(tree, rows=train);

rms(y[test], predict(tree, rows=test))

@load RandomForestRegressor pkg=ScikitLearn

coerce!(X, Finite => Count);

rf_mdl = RandomForestRegressor()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

rms(y[test], predict(rf, rows=test))

cv3 = CV(; nfolds=3)
res = evaluate(rf_mdl, X, y, resampling=CV(shuffle=true),
               measure=rms, verbosity=0)

@load XGBoostRegressor

coerce!(X, Count => Continuous)

xgb  = XGBoostRegressor()
xgbm = machine(xgb, X, y)
fit!(xgbm, rows=train)

rms(y[test], predict(xgbm, rows=test))

r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :num_round, lower=1, upper=25);

tm = TunedModel(model=xgb, tuning=Grid(resolution=7),
                resampling=CV(rng=11), ranges=[r1,r2],
                measure=rms)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)

rms(y[test], predict(mtm, rows=test))

PyPlot.close_figs() # hide

