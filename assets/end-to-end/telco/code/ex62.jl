# This file was generated, do not modify it. # hide
e_tuned_iterated_pipe = evaluate(tuned_iterated_pipe, X, y,
                                 resampling=StratifiedCV(nfolds=6, rng=123),
                                 measures=[brier_loss, auc, accuracy])