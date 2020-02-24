# This file was generated, do not modify it. # hide
figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
xlabel("Number of rounds", fontsize=14)
ylabel("HingeLoss", fontsize=14)
xticks([10, 100, 200, 500], fontsize=12)

savefig(joinpath(@OUTPUT, "EX-crabs-xgb-curve1.svg")) # hide