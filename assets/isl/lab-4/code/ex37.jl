# This file was generated, do not modify it. # hide
fprs, tprs, thresholds = roc(ŷ, y[test])

figure(figsize=(8,6))
plot(fprs, tprs)

xlabel("False Positive Rate", fontsize=14)
ylabel("True Positive Rate", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "ISL-lab-4-roc.svg")) # hide