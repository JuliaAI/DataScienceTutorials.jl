# This file was generated, do not modify it. # hide
ŷ = predict_mode(mach, Xtrain)
mcr = misclassification_rate(ŷ, ytrain)
println(rpad("MNC mcr:", 10), round(mcr, sigdigits=3))