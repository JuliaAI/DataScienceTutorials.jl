# This file was generated, do not modify it. # hide
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=333)
fit!(mach, rows=train)
ypred = predict_mode(mach, rows=test)
misclassification_rate(ypred, y[test])