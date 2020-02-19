# This file was generated, do not modify it. # hide
using PyPlot
figure(figsize=(8,6))
plot(r.parameter_values, r.measurements)

xticks(1:5, fontsize=12)
yticks(fontsize=12)
xlabel("Maximum depth", fontsize=14)
ylabel("Misclassification rate", fontsize=14)
ylim([0, 1])

savefig("assets/literate/A-model-tuning-hpt.svg") # hide