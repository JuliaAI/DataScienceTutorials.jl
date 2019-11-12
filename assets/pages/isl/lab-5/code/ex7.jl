# This file was generated, do not modify it. # hide
get_mse(lr) = rms(predict(lr, rows=test), y[test])^2

@show get_mse(lr1)
@show get_mse(lr2)
@show get_mse(lr3)