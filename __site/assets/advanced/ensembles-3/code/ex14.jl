# This file was generated, do not modify it. # hide
r = range(
    atom,
    :min_samples_split,
    lower=2,
    upper=100,
    scale=:log,
)

mach = machine(atom, X, y)

curve = learning_curve(
    mach,
    range=r,
    measure=mav,
    resampling=CV(nfolds=6),
    verbosity=0,
)

using Plots
plot(curve.parameter_values, curve.measurements)
xlabel!(curve.parameter_name)

savefig(joinpath(@OUTPUT, "e1.svg")); # hide