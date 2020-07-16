# This file was generated, do not modify it. # hide
ŷ = MLJ.predict(LinearModel, X)
yhatResponse = [ŷ[i,1] for i in 1:nrow(y)]
residuals = y .- yhatResponse
r = report(LinearModel)

k = collect(keys(fp.fitted_params_given_machine))[3]
println("\n Coefficients:  ", fp.fitted_params_given_machine[k].coefs)
println("\n y \n ", y[1:5,1])
println("\n ŷ \n ", ŷ[1:5])
println("\n yhatResponse \n ", yhatResponse[1:5])
println("\n Residuals \n ", y[1:5,1] .- yhatResponse[1:5])