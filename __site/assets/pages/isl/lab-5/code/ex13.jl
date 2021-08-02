# This file was generated, do not modify it. # hide
Xnew = DataFrame([hpn.^i for i in 1:10])
yy5 = predict(mtm, Xnew)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy5, lw=3)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig("assets/literate/ISL-lab-5-g4.svg") # hide