# This file was generated, do not modify it. # hide
mc = machine(MultinomialClassifier(), Xtrain, ytrain)
res = evaluate!(mc; opts...)
round(res.measurement[1], sigdigits=3)