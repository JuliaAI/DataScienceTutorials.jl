# This file was generated, do not modify it. # hide
metrics = [log_loss, accuracy]
evaluate(
    pipe, Xtrain, ytrain;
    resampling = Holdout(fraction_train=0.9),
    measures = metrics,
)