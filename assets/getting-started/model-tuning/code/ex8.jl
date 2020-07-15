# This file was generated, do not modify it. # hide
using PyPlot
figure(figsize=(8,6))
res = r.plotting # contains all you need for plotting
plot(res.parameter_values, res.measurements, ls="none", marker="o")

xticks(1:5, fontsize=12)
yticks(fontsize=12)
xlabel("Maximum depth", fontsize=14)
ylabel("Misclassification rate", fontsize=14)
ylim([0, 1])

savefig(joinpath(@OUTPUT, "A-model-tuning-hpt.svg")) # hide