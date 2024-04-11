# This file was generated, do not modify it. # hide
hpn  = xx.Horsepower
Xnew = DataFrame(hp1=hpn, hp2=hpn.^2, hp3=hpn.^3)

yy1 = MLJ.predict(lr1, Xnew)
yy2 = MLJ.predict(lr2, Xnew)
yy3 = MLJ.predict(lr3, Xnew)

plot(X.Horsepower, y, seriestype=:scatter, label=false,  size=(800,600))
plot!(xx.Horsepower, yy1,  label="Order 1", linewidth=3, color=:orange,)
plot!(xx.Horsepower, yy2,  label="Order 2", linewidth=3, color=:green,)
plot!(xx.Horsepower, yy3,  label="Order 3", linewidth=3, color=:red,)

xlabel!("Horsepower")
ylabel!("MPG")

savefig(joinpath(@OUTPUT, "ISL-lab-5-g3.svg")); # hide