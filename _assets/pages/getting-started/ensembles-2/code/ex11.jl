# This file was generated, do not modify it. # hide
r = report(m)

figure(figsize=(8,6))

vals_sf = r.parameter_values[:, 1]
vals_bf = r.parameter_values[:, 2]

tricontourf(vals_sf, vals_bf, r.measurements)
xticks(1:3:12, fontsize=12)
xlabel("Number of sub-features", fontsize=14)
yticks(0.4:0.2:1, fontsize=12)
ylabel("Bagging fraction", fontsize=14)

savefig("assets/literate/A-ensembles-2-heatmap.svg") # hide