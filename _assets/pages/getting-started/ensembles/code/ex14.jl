# This file was generated, do not modify it. # hide
using PyPlot

figure(figsize=(8,6))

vals_b = r.parameter_values[:, 1]
vals_k = r.parameter_values[:, 2]

tricontourf(vals_b, vals_k, r.measurements)
xticks(0.5:0.1:1, fontsize=12)
xlabel("Bagging fraction", fontsize=14)
yticks([1, 5, 10, 15, 20], fontsize=12)
ylabel("Number of neighbors - K", fontsize=14)

savefig("assets/literate/A-ensembles-heatmap.svg") # hide