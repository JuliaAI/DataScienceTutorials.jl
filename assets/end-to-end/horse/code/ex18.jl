# This file was generated, do not modify it. # hide
model = SimplePipe
lambdas = range(model, :(multinomial_classifier.lambda), lower=1e-3, upper=100, scale=:log10)
tm = TunedModel(model=SimplePipe, ranges=lambdas, measure=cross_entropy)
mtm = machine(tm, Xtrain, ytrain)
fit!(mtm)
best_pipe = fitted_params(mtm).best_model