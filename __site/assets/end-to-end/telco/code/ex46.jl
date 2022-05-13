# This file was generated, do not modify it. # hide
function confidence_intervals(e)
    factor = 2.0 # to get level of 95%
    measure = e.measure
    nfolds = length(e.per_fold[1])
    measurement = [e.measurement[j] ± factor*std(e.per_fold[j])/sqrt(nfolds - 1)
                   for j in eachindex(measure)]
    table = (measure=measure, measurement=measurement)
    return DataFrames.DataFrame(table)
end

confidence_intervals_basic_model = confidence_intervals(e_pipe)