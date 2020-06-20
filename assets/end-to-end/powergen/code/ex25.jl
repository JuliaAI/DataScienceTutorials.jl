# This file was generated, do not modify it. # hide
figure(figsize=(12, 6))
stem(res)
xlim(0, length(res))

savefig(joinpath(@OUTPUT, "residuals.png")) # hide