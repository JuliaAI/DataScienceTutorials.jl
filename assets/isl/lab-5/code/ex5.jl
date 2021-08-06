# This file was generated, do not modify it. # hide
lm = LR()
mlm = machine(lm, select(X, :Horsepower), y)
fit!(mlm, rows=train)
rms(MLJ.predict(mlm, rows=test), y[test])^2