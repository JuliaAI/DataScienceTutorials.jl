# This file was generated, do not modify it. # hide
Xnew = DataFrame([hpn.^i for i in 1:10], :auto)
yy5 = MLJ.predict(mtm, Xnew)

plot(X.Horsepower, y, seriestype=:scatter, legend=false,  size=(800,600))
plot!(xx.Horsepower, yy5, color=:orange, linewidth=4, legend=false)
xlabel!("Horsepower")
ylabel!("MPG")

savefig(joinpath(@OUTPUT, "ISL-lab-5-g4.svg")); # hide