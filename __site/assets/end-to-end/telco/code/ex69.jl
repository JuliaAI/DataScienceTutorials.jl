# This file was generated, do not modify it. # hide
mach_basic = machine(pipe, X, y)
fit!(mach_basic, verbosity=0)

ŷ_basic = predict(mach_basic, Xtest);

print(
    "Basic model measurements on test set:\n",
    "  brier loss: ", brier_loss(ŷ_basic, ytest), "\n",
    "  auc:        ", auc(ŷ_basic, ytest),                "\n",
    "  accuracy:   ", accuracy(mode.(ŷ_basic), ytest)
)

rm("tuned_iterated_pipe.jls") # hide