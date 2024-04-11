# This file was generated, do not modify it. # hide
mach = machine(model_nn, Xtrain, ytrain) |> fit!
yhat_nn = predict_mode(mach, Xtest);
confusion_matrix(yhat_nn, ytest)