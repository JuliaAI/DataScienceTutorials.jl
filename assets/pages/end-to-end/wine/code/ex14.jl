# This file was generated, do not modify it. # hide
mcr_k = misclassification_rate(predict_mode(knn, Xtrain), ytrain)
mcr_m = misclassification_rate(predict_mode(multi, Xtrain), ytrain)
println(rpad("KNN mcr:", 10), round(mcr_k, sigdigits=3))
println(rpad("MNC mcr:", 10), round(mcr_m, sigdigits=3))