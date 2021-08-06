# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/EX-GLM/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ, CategoricalArrays, PrettyPrinting
import DataFrames: DataFrame, nrow
using UrlDownload

LinearRegressor = @load LinearRegressor pkg=GLM
LinearBinaryClassifier = @load LinearBinaryClassifier pkg=GLM

baseurl = "https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data/glm/"

dfX = DataFrame(urldownload(baseurl * "X3.csv"))
dfYbinary = DataFrame(urldownload(baseurl * "Y3.csv"))
dfX1 = DataFrame(urldownload(baseurl * "X1.csv"))
dfY1 = DataFrame(urldownload(baseurl * "Y1.csv"));

first(dfX, 3)

first(dfY1, 3)

ms = models() do m
    AbstractVector{Count} <: m.target_scitype
end
foreach(m -> println(m.name), ms)

ms = models() do m
    Vector{Continuous} <: m.target_scitype
end
foreach(m -> println(m.name), ms)

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
println("\n Standard Error per Coefficient \n", r.linear_regressor.stderror[2:end])

round(rms(yhatResponse, y[:,1]), sigdigits=4)

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

ŷ = MLJ.predict(LogisticModel, X)
residuals = [1 - pdf(ŷ[i], y[i,1]) for i in 1:nrow(y)]
r = report(LogisticModel)

k = collect(keys(fp.fitted_params_given_machine))[3]
println("\n Coefficients:  ", fp.fitted_params_given_machine[k].coef)
println("\n y \n ", y[1:5,1])
println("\n ŷ \n ", ŷ[1:5])
println("\n residuals \n ", residuals[1:5])
println("\n Standard Error per Coefficient \n", r.linear_binary_classifier.stderror[2:end])

yMode = [mode(ŷ[i]) for i in 1:length(ŷ)]
y = coerce(y[:,1], OrderedFactor)
yMode = coerce(yMode, OrderedFactor)
confusion_matrix(yMode, y)

