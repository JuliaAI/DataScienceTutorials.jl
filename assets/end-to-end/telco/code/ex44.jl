# This file was generated, do not modify it. # hide
e_pipe = evaluate(pipe, X, y,
                  resampling=StratifiedCV(nfolds=6, rng=123),
                  measures=[brier_loss, auc, accuracy],
                  repeats=3,
                  acceleration=CPUThreads())