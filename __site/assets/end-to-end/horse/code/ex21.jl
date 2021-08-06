# This file was generated, do not modify it. # hide
mcr = misclassification_rate(mode.(ŷ), ytrain)
println(rpad("MNC mcr:", 10), round(mcr, sigdigits=3))