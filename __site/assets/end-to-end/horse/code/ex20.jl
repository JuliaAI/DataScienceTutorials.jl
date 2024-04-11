# This file was generated, do not modify it. # hide
mach = machine(pipe, Xtrain, ytrain) |> fit!
fit!(mach, verbosity=0)
yhat_prob = predict(mach, X[test,:])
m = log_loss(yhat_prob, y[test])
println("log loss: ", round(m, sigdigits=4))

yhat = mode.(yhat_prob)
m = accuracy(yhat, y[test])
println("accuracy: ", round(m, sigdigits=4))