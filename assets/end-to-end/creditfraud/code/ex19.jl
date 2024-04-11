# This file was generated, do not modify it. # hide
r = range(model_logit, :lambda, lower=1e-6, upper=100, scale=:log)

self_tuning_logit_model = TunedModel(
    model_logit,
    tuning = Grid(resolution=10),
    resampling = CV(nfolds=3),
    range = r,
    measure = misclassification_rate,
)

mach = machine(self_tuning_logit_model, Xtrain, ytrain) |> fit!