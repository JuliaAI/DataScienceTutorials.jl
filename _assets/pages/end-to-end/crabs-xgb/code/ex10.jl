# This file was generated, do not modify it. # hide
r = report(mtm)

md = r.parameter_values[:,1]
mcw = r.parameter_values[:,2]

figure(figsize=(8,6))
tricontourf(md, mcw, r.measurements)

xlabel("Maximum tree depth", fontsize=14)
ylabel("Minimum child weight", fontsize=14)
xticks(3:2:10, fontsize=12)
yticks(fontsize=12)

savefig("assets/literate/EX-crabs-xgb-heatmap.svg") # hide