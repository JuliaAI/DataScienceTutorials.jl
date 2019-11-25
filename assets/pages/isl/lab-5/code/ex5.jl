# This file was generated, do not modify it. # hide
xx = (Horsepower=range(50, 225, length=100) |> collect, )
yy = predict(mlm, xx)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy, lw=3)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig("assets/literate/ISL-lab-5-g2.svg") # hide