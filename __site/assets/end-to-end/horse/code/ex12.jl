# This file was generated, do not modify it. # hide
for name in names(data)
    col = data[all, name]
    ratio_missing = sum(ismissing.(col)) / length(all) * 100
    println(rpad(name, 30), round(ratio_missing, sigdigits=3))
end