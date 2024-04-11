# This file was generated, do not modify it. # hide
opts = (
    resampling=Holdout(fraction_train=0.9),
    measures=[log_loss, accuracy],
)
evaluate!(knn; opts...)