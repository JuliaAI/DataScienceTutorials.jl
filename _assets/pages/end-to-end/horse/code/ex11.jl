# This file was generated, do not modify it. # hide
for name in names(datac)
    col = datac[:, name]
    ratio_missing = sum(ismissing.(col)) / nrows(datac) * 100
    println(rpad(name, 30), round(ratio_missing, sigdigits=3))
end