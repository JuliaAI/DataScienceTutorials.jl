# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/EX-horse/Project.toml")
Pkg.update()

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

datac = coerce(data, autotype(data));

sch = schema(datac)
for (name, scitype) in zip(sch.names, sch.scitypes)
    println(rpad("$name", 30), scitype)
end

length(unique(datac.hospital_number))

datac = select!(datac, Not(:hospital_number));

datac = coerce(datac, autotype(datac, rules=(:discrete_to_continuous,)));

missing_outcome = ismissing.(datac.outcome)
idx_missing_outcome = missing_outcome |> findall

train = setdiff!(train |> collect, idx_missing_outcome)
test = setdiff!(test |> collect, idx_missing_outcome)
datac = datac[.!missing_outcome, :];

for name in names(datac)
    col = datac[:, name]
    ratio_missing = sum(ismissing.(col)) / nrows(datac) * 100
    println(rpad(name, 30), round(ratio_missing, sigdigits=3))
end

unwanted = [:peripheral_pulse, :nasogastric_tube, :nasogastric_reflux,
        :nasogastric_reflux_ph, :feces, :abdomen, :abdomcentesis_appearance, :abdomcentesis_total_protein]
select!(datac, Not(unwanted));

@load FillImputer
filler = machine(FillImputer(), datac)
fit!(filler)
datac = MLJ.transform(filler, datac)

y, X = unpack(datac, ==(:outcome), name->true);
X = coerce(X, autotype(X, :discrete_to_continuous));

@load OneHotEncoder
MultinomialClassifier = @load MultinomialClassifier pkg="MLJLinearModels"

Xtrain = X[train,:]
ytrain = y[train];

SimplePipe = Pipeline(
    OneHotEncoder(),
    MultinomialClassifier(),
    prediction_type=:probabilistic
)
mach = machine(SimplePipe, Xtrain, ytrain)
res = evaluate!(
    mach;
    resampling=Holdout(fraction_train=0.9),
    measure=cross_entropy
)
round(res.measurement[1], sigdigits=3)

mcr = misclassification_rate(predict_mode(mach, Xtrain), ytrain)
println(rpad("MNC mcr:", 10), round(mcr, sigdigits=3))

model = SimplePipe
lambdas = range(model, :(multinomial_classifier.lambda), lower=1e-3, upper=100, scale=:log10)
tm = TunedModel(model=SimplePipe, ranges=lambdas, measure=cross_entropy)
mtm = machine(tm, Xtrain, ytrain)
fit!(mtm)
best_pipe = fitted_params(mtm).best_model

ŷ = MLJ.predict(mtm, Xtrain)
cross_entropy(ŷ, ytrain) |> mean

mcr = misclassification_rate(mode.(ŷ), ytrain)
println(rpad("MNC mcr:", 10), round(mcr, sigdigits=3))

XGBC = @load XGBoostClassifier
dtc = machine(XGBC(), Xtrain, ytrain)
fit!(dtc)
ŷ = MLJ.predict(dtc, Xtrain)
cross_entropy(ŷ, ytrain) |> mean

misclassification_rate(mode.(ŷ), ytrain)

