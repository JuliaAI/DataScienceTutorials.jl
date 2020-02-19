# This file was generated, do not modify it. # hide
r = report(mtm)

res = r.plotting

ss = res.parameter_values[:,1]
cbt = res.parameter_values[:,2]

figure(figsize=(8,6))
tricontourf(ss, cbt, res.measurements)

xlabel("Sub sample", fontsize=14)
ylabel("Col sample by tree", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "EX-crabs-xgb-heatmap2.svg")) # hide