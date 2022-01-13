# This file was generated, do not modify it. # hide
ŷ = MLJ.predict(LogisticModel, X)
residuals = [1 - pdf(ŷ[i], y[i,1]) for i in 1:nrow(y)]
r = report(LogisticModel)

k = collect(keys(fp.fitted_params_given_machine))[3]
println("\n Coefficients:  ", fp.fitted_params_given_machine[k].coef)
println("\n y \n ", y[1:5,1])
println("\n ŷ \n ", ŷ[1:5])
println("\n residuals \n ", residuals[1:5])
println("\n Standard Error per Coefficient \n", r.linear_binary_classifier.stderror[2:end])