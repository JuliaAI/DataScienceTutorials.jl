# This file was generated, do not modify it. # hide
figure(figsize=(8,6))
plot(curves.parameter_values, curves.measurements)
ylabel("Root Mean Squared error", fontsize=16)
xlabel("Number of trees", fontsize=16)
xticks([10, 250, 500, 750, 1000], fontsize=14)
yticks(fontsize=14)

savefig(joinpath(@OUTPUT, "A-ensembles-2-curves.svg")) # hide