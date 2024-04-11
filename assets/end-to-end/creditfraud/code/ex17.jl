# This file was generated, do not modify it. # hide
false_positive_rates, true_positive_rates, thresholds =
    roc_curve(yhat, ytest)
plot(false_positive_rates, true_positive_rates)
plot!([0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:black, label=:none)
xlabel!("false positive rate")
ylabel!("true positive rate")

savefig(joinpath(@OUTPUT, "EX-creditfraud-roc.svg")); # hide