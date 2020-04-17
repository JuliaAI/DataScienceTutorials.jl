# This file was generated, do not modify it. # hide
r = report(rfr_tm)
res = r.plotting

md = res.parameter_values[:,1]
mcw = res.parameter_values[:,2]

figure(figsize=(8,6))
tricontourf(md, mcw, res.measurements)

xlabel("Number of trees", fontsize=14)
ylabel("Sampling fraction", fontsize=14)
xticks(9:1:15, fontsize=12)
yticks(fontsize=12)
plt.savefig(joinpath(@OUTPUT, "airfoil_heatmap.svg")) # hide