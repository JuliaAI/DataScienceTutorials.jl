# This file was generated, do not modify it. # hide
Xc2 = select(Xc, Not([:League, :Division, :NewLeague]))
pipe2 = machine(model, Xc2, y)
fit!(pipe2, rows=train)
ŷ = predict(pipe2, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)