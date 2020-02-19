# This file was generated, do not modify it. # hide
figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
xlabel("Number of rounds", fontsize=14)
ylabel("Cross entropy", fontsize=14)
xticks([10, 100, 200, 500], fontsize=12)
yticks(1.46:0.005:1.475, fontsize=12)

savefig("assets/literate/EX-crabs-xgb-curve1.svg") # hide