# This file was generated, do not modify it. # hide
fit!(multinom) # train on all train data
yhat = predict_mode(multinom, Xtest)
accuracy(yhat, ytest)