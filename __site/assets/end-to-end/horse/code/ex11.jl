# This file was generated, do not modify it. # hide
train = setdiff!(train |> collect, idx_missing_outcome)
test = setdiff!(test |> collect, idx_missing_outcome)
all = vcat(train, test);