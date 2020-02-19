# This file was generated, do not modify it. # hide
fp = fitted_params(mach_uni)
@show round.(fp.coefs, sigdigits=3)
@show round(fp.intercept, sigdigits=3)