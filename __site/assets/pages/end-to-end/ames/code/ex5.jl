# This file was generated, do not modify it. # hide
train, test = partition(eachindex(y), 0.70, shuffle=true); # 70:30 split
fit!(cmach, rows=train)
ŷ = predict(cmach, rows=test)
ŷ[1:3] |> pprint