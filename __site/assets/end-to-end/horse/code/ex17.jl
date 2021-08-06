# This file was generated, do not modify it. # hide
SimplePipe = @pipeline(OneHotEncoder(),
                       MultinomialClassifier(), prediction_type=:probabilistic)
mach = machine(SimplePipe, Xtrain, ytrain)
res = evaluate!(mach; resampling=Holdout(fraction_train=0.9),
                measure=cross_entropy)
round(res.measurement[1], sigdigits=3)