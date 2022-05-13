# This file was generated, do not modify it. # hide
print(
    "Tuned model measurements on test:\n",
    "  brier loss: ", brier_loss(ŷ_tuned, ytest) |> mean, "\n",
    "  auc:        ", auc(ŷ_tuned, ytest),                "\n",
    "  accuracy:   ", accuracy(mode.(ŷ_tuned), ytest)
)