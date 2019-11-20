# This file was generated, do not modify it. # hide
using PyPlot

figure(figsize=(8,6))
res = ŷ .- y
stem(res)

savefig("assets/literate/ISL-lab-3-res.svg") # hide