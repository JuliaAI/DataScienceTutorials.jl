# This file was generated, do not modify it. # hide
model_svm = Standardizer() |>  SVC()
mach = machine(model_svm, Xtrain, ytrain) |> fit!
yhat_svm = predict(mach, Xtest)
confusion_matrix(yhat_svm, ytest)