# This file was generated, do not modify it. # hide
pipe.model.linear_regressor = RidgeRegressor()
fit!(pipe, rows=train)
ŷ = predict(pipe, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)