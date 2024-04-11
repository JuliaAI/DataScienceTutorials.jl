# This file was generated, do not modify it. # hide
Xnew = (LStat = Xnew.LStat, LStat2 = Xnew.LStat.^2)

plot(X.LStat, y, seriestype=:scatter, markershape=:circle, legend=false, size=(800,600))
plot!(Xnew.LStat, MLJ.predict(mach, Xnew), linewidth=3, color=:orange)

savefig(joinpath(@OUTPUT, "ISL-lab-3-lreg.svg")); # hide