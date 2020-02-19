# This file was generated, do not modify it. # hide
B_range = range(ensemble_model, :bagging_fraction,
                lower=0.5, upper=1.0)
K_range = range(ensemble_model, :(atom.K),
                lower=1, upper=20);