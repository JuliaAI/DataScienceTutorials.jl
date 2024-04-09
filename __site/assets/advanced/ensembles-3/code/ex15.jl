# This file was generated, do not modify it. # hide
atom_rand = DecisionTreeRegressor(n_subfeatures=4)
forest = MyEnsemble(atom_rand, 100)

r = range(
    forest,
    :(atom.min_samples_split),
    lower=2,
    upper=100,
    scale=:log,
)

mach = machine(forest, X, y)

curve = learning_curve(
    mach,
    range=r,
    measure=mav,
    resampling=CV(nfolds=6),
    verbosity=0,
    acceleration_grid=CPUThreads(),
)

plot(curve.parameter_values, curve.measurements)
xlabel!(curve.parameter_name)

savefig(joinpath(@OUTPUT, "e2.svg")); # hide