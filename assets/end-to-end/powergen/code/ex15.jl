# This file was generated, do not modify it. # hide
histogram(data.Wind_gen, color = "blue", bins = 50, normalize = :pdf, alpha = 0.5)
xlabel!("Wind power generation (MWh)")
ylabel!("Frequency")

savefig(joinpath(@OUTPUT, "hist_wind.svg")); # hide