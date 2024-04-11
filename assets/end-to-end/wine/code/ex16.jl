# This file was generated, do not modify it. # hide
fit!(knn) # train on all train data
yhat = predict_mode(knn, Xtest)
accuracy(yhat, ytest)