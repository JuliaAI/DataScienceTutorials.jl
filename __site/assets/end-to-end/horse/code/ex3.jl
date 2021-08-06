# This file was generated, do not modify it. # hide
unwanted = [:lesion_1, :lesion_2, :lesion_3]
data = vcat(data_train, data_test)
select!(data, Not(unwanted));