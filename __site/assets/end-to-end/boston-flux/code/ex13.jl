# This file was generated, do not modify it. # hide
# Inspecting out-of-sample loss as a function of epochs

r = MLJ.range(nnregressor, :epochs, lower=1, upper=30, scale=:log10)
curve = MLJ.learning_curve(nnregressor, features, targets,
                       range=r,
                       resampling=MLJ.Holdout(fraction_train=0.7),
                       measure=MLJ.l2)

plot(curve.parameter_values,
    curve.measurements,
    xlab=curve.parameter_name,
    xscale=curve.parameter_scale,
    ylab = "l2")
# Tuning