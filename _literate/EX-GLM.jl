# **Main author**: [Clarman Cruz](https://github.com/drcxcruz).
#
# This juypter lab showcases MLJ in particular using the popular [GLM](https://github.com/JuliaStats/GLM.jl) Julia package. We are using two datasets.  One dataset was created manually for testing purposes.  The other data set is the CollegeDistance dataset from the [AER](https://cran.r-project.org/web/packages/AER/index.html) package in R.
#
# We can quickly define our models in MLJ and study their results.  It is very easy and consistent.

using MLJ, CategoricalArrays, PrettyPrinting
import DataFrames: DataFrame, nrow
using UrlDownload
const LinearRegressor = @load LinearRegressor pkg = GLM
const LinearBinaryClassifier = @load LinearBinaryClassifier pkg=GLM

# ## Reading the data
#
# The CollegeDistance dataset was stored in a CSV file.  Here, we read the input file.

baseurl = "https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data/glm/"

dfX = DataFrame(urldownload(baseurl * "X3.csv"))
dfYbinary = DataFrame(urldownload(baseurl * "Y3.csv"))
dfX1 = DataFrame(urldownload(baseurl * "X1.csv"))
dfY1 = DataFrame(urldownload(baseurl * "Y1.csv"));

# You can have a look at those using `first`:

first(dfX, 3)

# same for Y:

first(dfY1, 3)

# ## Defining the Linear Model
#
# Let see how many MLJ models handle our kind of target which is the y variable.

ms = models() do m
    AbstractVector{Count} <: m.target_scitype
end
foreach(m -> println(m.name), ms)

# How about if the type was Continuous:

ms = models() do m
    Vector{Continuous} <: m.target_scitype
end
foreach(m -> println(m.name), ms)

# We can quickly define our models in MLJ.  It is very easy and consistent.

X = copy(dfX1)
y = copy(dfY1)

coerce!(X, autotype(X, :string_to_multiclass))
yv = Vector(y[:, 1])

LinearRegressorPipe = @pipeline(Standardizer(),
                                OneHotEncoder(drop_last = true),
                                LinearRegressor())

LinearModel = machine(LinearRegressorPipe, X, yv)
fit!(LinearModel)
fp = fitted_params(LinearModel)

# ## Reading the Output of Fitting the Linear Model
#
# We can quickly read the results of our models in MLJ.  Remember to compute the accuracy of the linear model.

ŷ = MLJ.predict(LinearModel, X)
yhatResponse = [ŷ[i,1].μ for i in 1:nrow(y)]
residuals = y .- yhatResponse
r = report(LinearModel)

k = collect(keys(fp.fitted_params_given_machine))[3]
println("\n Coefficients:  ", fp.fitted_params_given_machine[k].coef)
println("\n y \n ", y[1:5,1])
println("\n ŷ \n ", ŷ[1:5])
println("\n yhatResponse \n ", yhatResponse[1:5])
println("\n Residuals \n ", y[1:5,1] .- yhatResponse[1:5])
println("\n Standard Error per Coefficient \n", r.report_given_machine[k].stderror)

# and get the accuracy

round(rms(yhatResponse, y[:,1]), sigdigits=4)

# ## Defining the Logistic Model

X = copy(dfX)
y = copy(dfYbinary)

coerce!(X, autotype(X, :string_to_multiclass))
yc = CategoricalArray(y[:, 1])
yc = coerce(yc, OrderedFactor)

LinearBinaryClassifierPipe = @pipeline(Standardizer(),
                                       OneHotEncoder(drop_last = true),
                                       LinearBinaryClassifier())

LogisticModel = machine(LinearBinaryClassifierPipe, X, yc)
fit!(LogisticModel)
fp = fitted_params(LogisticModel)

# ## Reading the Output from the Prediction of the Logistic Model
#
# The output of the MLJ model basically contain the same information as the R version of the model.

ŷ = MLJ.predict(LogisticModel, X)
residuals = [1 - pdf(ŷ[i], y[i,1]) for i in 1:nrow(y)]
r = report(LogisticModel)

k = collect(keys(fp.fitted_params_given_machine))[3]
println("\n Coefficients:  ", fp.fitted_params_given_machine[k].coef)
println("\n y \n ", y[1:5,1])
println("\n ŷ \n ", ŷ[1:5])
println("\n residuals \n ", residuals[1:5])
println("\n Standard Error per Coefficient \n", r.report_given_machine[k].stderror)

# No logistic analysis is complete without the confusion matrix:

yMode = [mode(ŷ[i]) for i in 1:length(ŷ)]
y = coerce(y[:,1], OrderedFactor)
yMode = coerce(yMode, OrderedFactor)
confusion_matrix(yMode, y)
