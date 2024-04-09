# This file was generated, do not modify it. # hide
LogisticClassifier = @load LogisticClassifier pkg=MLJLinearModels
model_logit = LogisticClassifier(lambda=1.0)
mach = machine(model_logit, Xtrain, ytrain) |> fit!