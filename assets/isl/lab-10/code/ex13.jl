# This file was generated, do not modify it. # hide
p = plot(size=(800,600))
legend_items = ["Group 1", "Group 2", "Group 3"]
for (i, (m, c)) in enumerate(zip((mask1, mask2, mask3), ("red", "green", "blue")))
    scatter!(p, W[m, 1], W[m, 2], color=c, label=legend_items[i])
end
plot(p)
xlabel!("PCA-1")
ylabel!("PCA-2")

savefig(joinpath(@OUTPUT, "ISL-lab-10-cluster.svg")); # hide