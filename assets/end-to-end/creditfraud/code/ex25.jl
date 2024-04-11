# This file was generated, do not modify it. # hide
r = range(model_svm, :(svc.cost), lower=0.1, upper=3.5, scale=:linear)
self_tuning_svm_model = TunedModel(
    model_svm,
    resampling = CV(nfolds=3),
    tuning = Grid(resolution=6),
    range = r,
    measure = misclassification_rate,
)
mach = machine(self_tuning_svm_model, Xtrain, ytrain) |> fit!

fitted_params(mach).best_model