# This file was generated, do not modify it. # hide
evaluate(
    knn_model,
    X,
    y;
    resampling=Holdout(fraction_train=0.7, rng=StableRNG(666)),
    measure=rms,
)