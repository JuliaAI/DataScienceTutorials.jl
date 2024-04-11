# This file was generated, do not modify it. # hide
lambdas = range(pipe, :(multinomial_classifier.lambda), lower=1e-3, upper=100, scale=:log10)
tuned_pipe = TunedModel(
    pipe;
    tuning=Grid(resolution=20),
    range=lambdas, measure=log_loss,
    acceleration=CPUThreads(),
)
mach = machine(tuned_pipe, Xtrain, ytrain) |> fit!
best_pipe = fitted_params(mach).best_model