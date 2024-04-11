# This file was generated, do not modify it. # hide
plot(curve.parameter_values, curve.measurements)
xlabel!("Number of rounds", fontsize=14)
ylabel!("Brier loss", fontsize=14)

savefig(joinpath(@OUTPUT, "EX-crabs-xgb-curve1.svg")); # hide