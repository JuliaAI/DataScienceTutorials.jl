# ## Baby steps
#
# https://mlr3gallery.mlr-org.com/house-prices-in-king-county/
#
using MLJ, PrettyPrinting, DataFrames, Statistics, CSV, Dates
MLJ.color_off() # hide
df = CSV.read(joinpath(@__DIR__, "kc_housing.csv"), missingstring="NA")
describe(df)
# First we convert the date column to numeric by first date range and then using the Dates.value function
df.date = Date.(df.date)
df.days = Dates.value.(df.date .- minimum(df.date))
# Afterwards, we convert the zip code to a factor:
# Turn Zipcode into Multiclass
coerce!(df, :zipcode => Multiclass)
df.isrenovated  = @. !ismissing(df.yr_renovated)
df.has_basement = @. !ismissing(df.sqft_basement)

#Hack to make everything a count
df[:waterfront]=df[:waterfront]  .!= "FALSE"
coerce!(df,:lat=> Continuous,:long=>Continuous,:isrenovated  => Count,:has_basement => Count, :view => Count, :condition    => Count,:days=>Count,:waterfront   => Count)








#We drop the id column which provides no information about the house prices:
# Additionally we convert the price from Dollar to units of 1000 Dollar to improve readability.
df.price = @. df.price / 1000
# Additionally, for now we simply drop the columns that have missing values, as some of our learners can not deal with them. A better option to deal with missing values would be imputation, i.e. replacing missing values with valid ones. We will deal with this in a separate article.
df = select!(df, Not([:yr_renovated, :sqft_basement,:sqft_lot15,:sqft_living15,:date]))



#  We can now plot the density of the price to get a first impression on its distribution.
using StatsPlots
pyplot()
@df df density(:price)

# We can observe that renovated flats seem to achieve higher sales values, and this might thus be a relevant feature.


@df df boxplowt!(:isrenovated,:price,marker=(0.3,:orange,stroke(2)), alpha=0.75)

plot()
# Additionally, we can for example look at the condition of the house. Again, we clearly can see that the price rises with increasing condition.
@df df boxplot!(:condition,:price,marker=(0.3,:orange,stroke(2)), alpha=0.75)

plot()
@df df corrplot([:condition :price :waterfront], grid = false)

@df df corrplot([:price :long :sqft_above :sqft_living], grid = false)

describe(df[:waterfront])


#Decision trees cannot only be used as a powerful tool for predictive models but also for exploratory data analysis. In order to fit a decision tree
using PrettyTables
df=select!(df, Not(:zipcode))

X=select(df, Not(:price))
y=select(df, (:price))[:price]
# Check that there is no Unknown scitype
@assert 0==length(findall(x-> x==Unknown,schema(X).scitypes ))

# Inspect manually to double check
print(schema(X).scitypes)

# TODO Why does this not work?
train, test = partition(eachindex(y), 0.7, shuffle=true);

tree_model = @load DecisionTreeRegressor verbosity=1
tree = machine(tree_model, X, y)
fit!(tree, rows=train);

# visualise tree

## Many Trees: Random Forest
#We might be able to improve upon the RMSE using more powerful learners.
using MLJModels
@load RandomForestRegressor pkg=ScikitLearn

coerce(df)

rf_mdl = RandomForestRegressor()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

cv3 = CV(; nfolds=3)
res=evaluate(rf_mdl, X, y,
               resampling=CV(shuffle=true), measure=rms, verbosity=0)


#. In this case, we resort to tune a different kind of model: Gradient Boosted Decision Trees from the package xgboost.
@load XGBoostRegressor
xgb = XGBoostRegressor()
xgbm=machine(xgb, X, y)
r=fit!(xgbm, rows=train)


r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :eta, lower=0.2, upper=.4)
r3 = range(xgb, :min_child_weight, lower=1, upper=20)
r4 = range(xgb, :subsample, lower=0.7, upper=0.8)
r5 = range(xgb, :colsample_bytree, lower=0.9, upper=1.0)
r6 = range(xgb, :colsample_bylevel, lower=0.5, upper=0.7)
r7 = range(xgb, :num_round, lower=1, upper=25)



tm=TunedModel(model=xgb, tuning=Grid(resolution=2),
                resampling=CV(rng=11), ranges=[r1,r2,r3,r4,r5,r6,r7],
                measure=rms)
mtm = machine(tm, X, y)
mtm_res=fit!(mtm, rows=train)


params(xgb_model)
# Tuning can often further improve the performance. In this case, we tune the xgboost learner in order to see whether this can improve performance.
# TODO nested cross validation


# In order to further improve our results we have several options:
#
#     Find or engineer better features
#     Remove Features to avoid overfitting
#     Obtain additional data (often prohibitive)
#     Try more models
#     Improve the tuning
#         Increase the tuning budget
#         Enlarge the tuning search space
#         Use a more efficient tuning algorithm
#     Stacking and Ensembles
#
# Below we will investigate some of those possibilities and investigate whether this improves performance.
