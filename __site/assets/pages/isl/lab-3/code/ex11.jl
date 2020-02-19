# This file was generated, do not modify it. # hide
println(rpad(" Feature", 11), "| ", "Coefficient")
println("-"^24)
for (i, name) in enumerate(names(X))
    println(rpad("$name", 11), "| ", round(fp.coefs[i], sigdigits=3))
end
println(rpad("Intercept", 11), "| ", round(fp.intercept, sigdigits=3))