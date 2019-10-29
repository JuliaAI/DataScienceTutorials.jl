# This file was generated, do not modify it. # hide
for col in names(Xc)
    x = Xc[:, col]
    μ = round(mean(x), sigdigits=2)
    σ = round(std(x), sigdigits=2)
    println(rpad(col, 30), lpad(μ, 5), "; " , lpad(σ, 5))
end