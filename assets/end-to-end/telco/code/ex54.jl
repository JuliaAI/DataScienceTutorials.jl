# This file was generated, do not modify it. # hide
tuned_iterated_pipe = TunedModel(model=iterated_pipe,
                                 range=[r1, r2],
                                 tuning=tuning,
                                 measures=[brier_loss, auc, accuracy],
                                 resampling=StratifiedCV(nfolds=6, rng=123),
                                 acceleration=CPUThreads(),
                                 n=40)