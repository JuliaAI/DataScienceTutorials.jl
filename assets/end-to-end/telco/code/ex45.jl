# This file was generated, do not modify it. # hide
ŷ = predict(mach_pipe, rows=validation);
print(
    "Measurements:\n",
    "  brier loss: ", brier_loss(ŷ, y[validation]), "\n",
    "  auc:        ", auc(ŷ, y[validation]),                "\n",
    "  accuracy:   ", accuracy(mode.(ŷ), y[validation])
)