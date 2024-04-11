# This file was generated, do not modify it. # hide
xx = (Horsepower=range(50, 225, length=100) |> collect, )
yy = MLJ.predict(mlm, xx)

plot(X.Horsepower, y, seriestype=:scatter, legend=false,  size=(800,600))
plot!(xx.Horsepower, yy,  legend=false, linewidth=3, color=:orange)
xlabel!("Horsepower")
ylabel!("MPG")


savefig(joinpath(@OUTPUT, "ISL-lab-5-g2.svg")); # hide