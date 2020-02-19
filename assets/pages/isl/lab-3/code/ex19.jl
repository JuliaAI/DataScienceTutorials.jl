# This file was generated, do not modify it. # hide
Xnew = (LStat = Xnew.LStat, LStat2 = Xnew.LStat.^2)

figure(figsize=(8,6))
plot(X.LStat, y, ls="none", marker="o")
plot(Xnew.LStat, predict(mach, Xnew))

savefig("assets/literate/ISL-lab-3-lreg.svg") # hide