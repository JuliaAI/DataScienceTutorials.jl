# This file was generated, do not modify it. # hide
figure(figsize=(8,6))
res = ŷ .- y
stem(res)

savefig(joinpath(@OUTPUT, "ISL-lab-3-res.svg")) # hide