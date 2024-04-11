# This file was generated, do not modify it. # hide
mach = machine(xgb, X, y)
curve = learning_curve(
    mach,
    range= range(xgb, :gamma, lower=0, upper=10),
    resolution=30,
    measure=brier_loss,
);

plot(curve.parameter_values, curve.measurements)
xlabel!("gamma", fontsize=14)
ylabel!("Brier loss", fontsize=14)

savefig(joinpath(@OUTPUT, "EX-crabs-xgb-gamma.svg")); # hide