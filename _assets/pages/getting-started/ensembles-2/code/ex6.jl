# This file was generated, do not modify it. # hide
figure(figsize=(8,6))
plot(curves.parameter_values, curves.measurements)
xlabel("Number of trees", fontsize=14)
xticks([10, 250, 500, 750, 1000])
ylim([4, 5])

savefig("assets/literate/A-ensembles-2-curves.svg")