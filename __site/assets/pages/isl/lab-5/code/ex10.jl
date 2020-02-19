# This file was generated, do not modify it. # hide
hpn  = xx.Horsepower
Xnew = DataFrame(hp1=hpn, hp2=hpn.^2, hp3=hpn.^3)

yy1 = predict(lr1, Xnew)
yy2 = predict(lr2, Xnew)
yy3 = predict(lr3, Xnew)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy1, lw=3, label="Order 1")
plot(xx.Horsepower, yy2, lw=3, label="Order 2")
plot(xx.Horsepower, yy3, lw=3, label="Order 3")

legend(fontsize=14)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig("assets/literate/ISL-lab-5-g3.svg") # hide