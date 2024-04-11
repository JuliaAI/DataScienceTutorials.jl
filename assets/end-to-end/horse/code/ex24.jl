# This file was generated, do not modify it. # hide
EvoTreeClassifier = @load EvoTreeClassifier
model = EvoTreeClassifier()
mach = machine(model, Xtrain, ytrain)
evaluate!(mach; resampling=CV(nfolds=6), measures=metrics)