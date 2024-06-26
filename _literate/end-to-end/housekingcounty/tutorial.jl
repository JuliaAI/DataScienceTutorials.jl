using Pkg # hideall
Pkg.activate("_literate/end-to-end/housekingcounty/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;


# @@dropdown
# ## Getting started
# @@
# @@dropdown-content
#
# This tutorial is adapted from [the corresponding MLR3 tutorial](https://mlr3gallery.mlr-org.com/posts/2020-01-30-house-prices-in-king-county/).
#

# @@dropdown
# ### Loading and  preparing the data
# @@
# @@dropdown-content

using MLJ
using PrettyPrinting
import DataFrames: DataFrame, select!, Not, describe
import Statistics
using Dates
using UrlDownload

MLJ.color_off() # hide

df = DataFrame(urldownload("https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data/kc_housing.csv", true))
describe(df)

# We drop unrelated columns

select!(df, Not([:id, :date]))
schema(df)

# Afterwards, we convert the zip code to an unordered factor (`Multiclass`), we also create two binary features `isrenovated` and `has_basement` derived from `yr_renovated` and `sqft_basement`:

coerce!(df, :zipcode => Multiclass)
df.isrenovated  = @. !iszero(df.yr_renovated)
df.has_basement = @. !iszero(df.sqft_basement)
schema(df)

# These created variables should be treated as OrderedFactor,

coerce!(df, :isrenovated => OrderedFactor, :has_basement => OrderedFactor);

# The feature `waterfront` is currently encoded as a string, but it's really just a boolean:

unique(df.waterfront)

# So let's recode it

df.waterfront = (df.waterfront .!= "FALSE")
coerce!(df, :waterfront => OrderedFactor);

# For a number of the remaining features which are treated as `Count` there are few unique values in which case it might make more sense to recode them as OrderedFactor, this can be done with `autotype`:

coerce!(df, autotype(df, :few_to_finite))
schema(df)

# Let's also rescale the column `price` to be in 1000s of dollars:

df.price = df.price ./ 1000;

# For simplicity let's just drop a few additional columns that don't seem to matter much:

select!(df, Not([:yr_renovated, :sqft_basement, :zipcode]));


# ‎
# @@
# @@dropdown
# ### Basic data visualisation
# @@
# @@dropdown-content
#
# Let's plot a basic histogram of the prices to get an idea for the distribution:

using Plots
Plots.scalefontsizes() #hide
Plots.scalefontsizes(1.2) #hide

histogram(df.price, color = "blue", normalize=:pdf, bins=50, alpha=0.5, legend=false)
xlabel!("Price")
ylabel!("Frequency")
savefig(joinpath(@OUTPUT, "hist_price.svg")); # hide

# \figalt{Histogram of the prices}{hist_price.svg}

# Let's see if there's a difference between renovated and unrenovated flats:

histogram(df.price[df.isrenovated .== true], color = "blue", normalize=:pdf, bins=50, alpha=0.5, label="renovated")
histogram!(df.price[df.isrenovated .== false], color = "red", normalize=:pdf, bins=50, alpha=0.5, label="unrenovated")
xlabel!("Price")
ylabel!("Frequency")
savefig(joinpath(@OUTPUT, "hist_price2.svg")); # hide

# \figalt{Histogram of the prices depending on renovation}{hist_price2.svg}
# We can observe that renovated flats seem to achieve higher sales values, and this might thus be a relevant feature.
#
#
# Likewise, this could be done to verify that `condition`, `waterfront` etc are important features.


# ‎
# @@

# ‎
# @@
# @@dropdown
# ## Fitting a first model
# @@
# @@dropdown-content

DTR = @load DecisionTreeRegressor pkg=DecisionTree

y, X = unpack(df, ==(:price))
train, test = partition(collect(eachindex(y)), 0.7, shuffle=true, rng=5)
tree = machine(DTR(), X, y)

fit!(tree, rows=train);

# Let's see how it does

rms(y[test], MLJ.predict(tree, rows=test))

# Let's try to do better.


# @@dropdown
# ### Random forest model
# @@
# @@dropdown-content

# We might be able to improve upon the RMSE using more powerful learners.

RFR = @load RandomForestRegressor pkg=MLJScikitLearnInterface

# That model only accepts input in the form of `Count` and so we have to coerce all `Finite` types into `Count`:

coerce!(X, Finite => Count);

# Now we can fit

rf_mdl = RFR()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

rms(y[test], MLJ.predict(rf, rows=test))

# A bit better but it would be best to check this a bit more carefully:

cv3 = CV(; nfolds=3)
res = evaluate(rf_mdl, X, y, resampling=CV(shuffle=true),
               measure=rms, verbosity=0)


# ‎
# @@
# @@dropdown
# ### GBM
# @@
# @@dropdown-content
#
# Let's try a different kind of model: Gradient Boosted Decision Trees from the package xgboost and we'll try to tune it too.

XGBR = @load XGBoostRegressor

# It expects a `Table(Continuous)` input so we need to coerce `X` again:

coerce!(X, Count => Continuous)

xgb  = XGBR()
xgbm = machine(xgb, X, y)
fit!(xgbm, rows=train)

rms(y[test], MLJ.predict(xgbm, rows=test))

# Let's try to tune it, first we define ranges for a number of useful parameters:

r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :num_round, lower=1, upper=25);

# And now we tune, we use a very coarse resolution because we use so many ranges, `2^7` is already some 128 models...

tm = TunedModel(model=xgb, tuning=Grid(resolution=7),
                resampling=CV(rng=11), ranges=[r1,r2],
                measure=rms)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)

rms(y[test], MLJ.predict(mtm, rows=test))

#


# ‎
# @@

# ‎
# @@
