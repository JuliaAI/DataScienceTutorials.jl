# This file was generated, do not modify it. # hide
perf_k = misclassification_rate(predict_mode(knn, Xtest), ytest)
perf_m = misclassification_rate(predict_mode(multi, Xtest), ytest)
println(rpad("KNN mcr:", 10), round(perf_k, sigdigits=3))
println(rpad("MNC mcr:", 10), round(perf_m, sigdigits=3))