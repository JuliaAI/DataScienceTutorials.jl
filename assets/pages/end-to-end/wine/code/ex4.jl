# This file was generated, do not modify it. # hide
for col in names(X)
    println(rpad(col, 30), scitype_union(X[:, col]))
end