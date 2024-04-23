# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/end-to-end/housekingcounty/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
using PrettyPrinting
import DataFrames: DataFrame, select!, Not, describe
import Statistics
using Dates
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

using Plots
Plots.scalefontsizes() #hide
Plots.scalefontsizes(1.2) #hide

histogram(df.price, color = "blue", normalize=:pdf, bins=50, alpha=0.5, legend=false)
xlabel!("Price")
ylabel!("Frequency")
savefig(joinpath(@OUTPUT, "hist_price.svg")); # hide

histogram(df.price[df.isrenovated .== true], color = "blue", normalize=:pdf, bins=50, alpha=0.5, label="renovated")
histogram!(df.price[df.isrenovated .== false], color = "red", normalize=:pdf, bins=50, alpha=0.5, label="unrenovated")
xlabel!("Price")
ylabel!("Frequency")
savefig(joinpath(@OUTPUT, "hist_price2.svg")); # hide

DTR = @load DecisionTreeRegressor pkg=DecisionTree

y, X = unpack(df, ==(:price))
train, test = partition(collect(eachindex(y)), 0.7, shuffle=true, rng=5)
tree = machine(DTR(), X, y)

fit!(tree, rows=train);

rms(y[test], MLJ.predict(tree, rows=test))

RFR = @load RandomForestRegressor pkg=MLJScikitLearnInterface

coerce!(X, Finite => Count);

rf_mdl = RFR()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

rms(y[test], MLJ.predict(rf, rows=test))

cv3 = CV(; nfolds=3)
res = evaluate(rf_mdl, X, y, resampling=CV(shuffle=true),
               measure=rms, verbosity=0)

XGBR = @load XGBoostRegressor

coerce!(X, Count => Continuous)

xgb  = XGBR()
xgbm = machine(xgb, X, y)
fit!(xgbm, rows=train)

rms(y[test], MLJ.predict(xgbm, rows=test))

r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :num_round, lower=1, upper=25);

tm = TunedModel(model=xgb, tuning=Grid(resolution=7),
                resampling=CV(rng=11), ranges=[r1,r2],
                measure=rms)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)

rms(y[test], MLJ.predict(mtm, rows=test))
