# This file was generated, do not modify it. # hide
X3 = hcat(X.LStat, X.LStat.^2) |> MLJ.table
mach = machine(mdl, X3, y)
fit!(mach)
ŷ = MLJ.predict(mach, X3)
round(rms(ŷ, y), sigdigits=4)