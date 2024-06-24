# This file was generated, do not modify it. # hide
train, test = partition(collect(eachindex(y)), 0.70, shuffle=true); # 70:30 split
fit!(mach, rows=train)
ŷ = predict(mach, rows=test);
ŷ[1:3]