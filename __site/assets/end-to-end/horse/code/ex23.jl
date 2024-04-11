# This file was generated, do not modify it. # hide
fit!(mach) # fit on all the train data
yhat = predict_mode(mach, X[test,:])
m = accuracy(yhat, y[test])
println("accuracy: ", round(m, sigdigits=4))