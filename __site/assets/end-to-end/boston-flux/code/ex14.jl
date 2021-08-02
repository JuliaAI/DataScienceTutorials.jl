# This file was generated, do not modify it. # hide
# Inspecting out-of-sample loss as a function of epochs

r = MLJ.range(nnregressor, :epochs, lower=1, upper=30, scale=:log10)
curve = MLJ.learning_curve(nnregressor, features, targets,
                       range=r,
                       resampling=MLJ.Holdout(fraction_train=0.7),
                       measure=MLJ.l2)

figure(figsize=(8,6))

plt.plot(curve.parameter_values,
    curve.measurements)

yscale("log")
xlabel(curve.parameter_name)
ylabel("l2")

savefig(joinpath(@OUTPUT, "EX-boston-flux-g1.svg")) # hide