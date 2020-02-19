# This file was generated, do not modify it. # hide
figure(figsize=(8,6))

res = r.plotting

vals_sf = res.parameter_values[:, 1]
vals_bf = res.parameter_values[:, 2]

tricontourf(vals_sf, vals_bf, res.measurements)
xlabel("Number of sub-features", fontsize=14)
ylabel("Bagging fraction", fontsize=14)
xticks([1, 2, 3], fontsize=12)
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "A-model-tuning-hm.svg")) # hide