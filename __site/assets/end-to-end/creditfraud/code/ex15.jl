# This file was generated, do not modify it. # hide
yhat_logit = predict_mode(mach, Xtest);
first(yhat_logit, 4)

# How does this model perform?

confusion_matrix(yhat_logit, ytest)