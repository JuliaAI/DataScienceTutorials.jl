# This file was generated, do not modify it. # hide
fprs, tprs, thresholds = roc_curve(ŷ, y[test])

plot(fprs, tprs, linewidth=2, size=(800,600))
xlabel!("False Positive Rate")
ylabel!("True Positive Rate")


savefig(joinpath(@OUTPUT, "ISL-lab-4-roc.svg")); # hide