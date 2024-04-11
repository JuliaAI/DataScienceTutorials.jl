# This file was generated, do not modify it. # hide
histogram(df.price[df.isrenovated .== true], color = "blue", normalize=:pdf, bins=50, alpha=0.5, label="renovated")
histogram!(df.price[df.isrenovated .== false], color = "red", normalize=:pdf, bins=50, alpha=0.5, label="unrenovated")
xlabel!("Price")
ylabel!("Frequency")
savefig(joinpath(@OUTPUT, "hist_price2.svg")); # hide