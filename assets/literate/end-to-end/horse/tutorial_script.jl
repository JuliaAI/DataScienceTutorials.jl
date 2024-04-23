# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/end-to-end/horse/Project.toml")
Pkg.instantiate()

using MLJ
MLJ.color_off() # hide
using HTTP
using CSV
import DataFrames: DataFrame, select!, Not
req1 = HTTP.get("http://archive.ics.uci.edu/ml/machine-learning-databases/horse-colic/horse-colic.data")
req2 = HTTP.get("http://archive.ics.uci.edu/ml/machine-learning-databases/horse-colic/horse-colic.test")
header = ["surgery", "age", "hospital_number",
    "rectal_temperature", "pulse",
    "respiratory_rate", "temperature_extremities",
    "peripheral_pulse", "mucous_membranes",
    "capillary_refill_time", "pain",
    "peristalsis", "abdominal_distension",
    "nasogastric_tube", "nasogastric_reflux",
    "nasogastric_reflux_ph", "feces", "abdomen",
    "packed_cell_volume", "total_protein",
    "abdomcentesis_appearance", "abdomcentesis_total_protein",
    "outcome", "surgical_lesion", "lesion_1", "lesion_2", "lesion_3",
    "cp_data"]
csv_opts = (header=header, delim=' ', missingstring="?",
            ignorerepeated=true)
data_train = CSV.read(req1.body, DataFrame; csv_opts...)
data_test  = CSV.read(req2.body, DataFrame; csv_opts...)
@show size(data_train)
@show size(data_test)

unwanted = [:lesion_1, :lesion_2, :lesion_3]
data = vcat(data_train, data_test)
select!(data, Not(unwanted));

train = 1:nrows(data_train)
test = last(train) .+ (1:nrows(data_test));

coerce!(data, autotype(data));

schema(data)

length(unique(data.hospital_number))

data = select!(data, Not(:hospital_number));

coerce!(data, Count => Continuous)
schema(data)

missing_outcome = ismissing.(data.outcome)
idx_missing_outcome = missing_outcome |> findall

train = setdiff!(train |> collect, idx_missing_outcome)
test = setdiff!(test |> collect, idx_missing_outcome)
all = vcat(train, test);

for name in names(data)
    col = data[all, name]
    ratio_missing = sum(ismissing.(col)) / length(all) * 100
    println(rpad(name, 30), round(ratio_missing, sigdigits=3))
end

unwanted = [:peripheral_pulse, :nasogastric_tube, :nasogastric_reflux,
            :nasogastric_reflux_ph, :feces, :abdomen,
            :abdomcentesis_appearance, :abdomcentesis_total_protein]
select!(data, Not(unwanted));

@load FillImputer
filler = machine(FillImputer(), data[all, :]) |> fit!
data = MLJ.transform(filler, data)

y, X = unpack(data, ==(:outcome)); # a vector and a table

@load OneHotEncoder
MultinomialClassifier = @load MultinomialClassifier pkg="MLJLinearModels"

Xtrain = X[train,:]
ytrain = y[train];

pipe = OneHotEncoder() |>  MultinomialClassifier()

metrics = [log_loss, accuracy]
evaluate(
    pipe, Xtrain, ytrain;
    resampling = Holdout(fraction_train=0.9),
    measures = metrics,
)

evaluate(pipe, Xtrain, ytrain; resampling=CV(nfolds=6), measures=metrics)

mach = machine(pipe, Xtrain, ytrain) |> fit!
fit!(mach, verbosity=0)
yhat_prob = predict(mach, X[test,:])
m = log_loss(yhat_prob, y[test])
println("log loss: ", round(m, sigdigits=4))

yhat = mode.(yhat_prob)
m = accuracy(yhat, y[test])
println("accuracy: ", round(m, sigdigits=4))

lambdas = range(pipe, :(multinomial_classifier.lambda), lower=1e-3, upper=100, scale=:log10)
tuned_pipe = TunedModel(
    pipe;
    tuning=Grid(resolution=20),
    range=lambdas, measure=log_loss,
    acceleration=CPUThreads(),
)
mach = machine(tuned_pipe, Xtrain, ytrain) |> fit!
best_pipe = fitted_params(mach).best_model

evaluate!(mach; resampling=CV(nfolds=6), measures=metrics)

fit!(mach) # fit on all the train data
yhat = predict_mode(mach, X[test,:])
m = accuracy(yhat, y[test])
println("accuracy: ", round(m, sigdigits=4))

EvoTreeClassifier = @load EvoTreeClassifier
model = EvoTreeClassifier()
mach = machine(model, Xtrain, ytrain)
evaluate!(mach; resampling=CV(nfolds=6), measures=metrics)

fit!(mach) # fit on all the train data
yhat = predict_mode(mach, X[test,:])
m = accuracy(yhat, y[test])
println("accuracy: ", round(m, sigdigits=4))
