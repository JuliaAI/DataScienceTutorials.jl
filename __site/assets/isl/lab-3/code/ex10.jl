# This file was generated, do not modify it. # hide
mach = machine(mdl, X, y)
fit!(mach)

fp = fitted_params(mach)
@show round.(fp.coefs[1:3], sigdigits=3)
@show round(fp.intercept, sigdigits=3)