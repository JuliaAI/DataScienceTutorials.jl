# This file was generated, do not modify it. # hide
rpt2 = report(mach_tuned_iterated_pipe);
best_booster = rpt2.best_model.model.evo_tree_classifier

print(
    "Optimal hyper-parameters: \n",
    "  max_depth: ", best_booster.max_depth, "\n",
    "  eta:         ", best_booster.eta
)