<!--This file was generated, do not modify it.-->
## Initial data processing

In this example, we consider the [UCI "horse colic" dataset](https://archive.ics.uci.edu/ml/datasets/Horse+Colic)

This is a reasonably messy classification problem with missing values etc and so some work should be expected in the feature processing.

### Getting the data

The data is pre-split in training and testing and we will keep it as such

```julia:ex1
using MLJ, StatsBase, ScientificTypes
using HTTP, CSV, DataFrames
req1 = HTTP.get("https://archive.ics.uci.edu/ml/machine-learning-databases/horse-colic/horse-colic.data")
req2 = HTTP.get("https://archive.ics.uci.edu/ml/machine-learning-databases/horse-colic/horse-colic.test")
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
data_train = CSV.read(req1.body; csv_opts...)
data_test  = CSV.read(req2.body; csv_opts...)
@show size(data_train)
@show size(data_test)
```

### Inspecting columns

To simplify the analysis, we will drop the columns `Lesion *` as they would need specific re-encoding which would distract us a bit.

```julia:ex2
unwanted = [:lesion_1, :lesion_2, :lesion_3]
data = vcat(data_train, data_test)
select!(data, Not(unwanted));
```

Let's also keep track of the initial train-test split

```julia:ex3
train = 1:nrows(data_train)
test = last(train) .+ (1:nrows(data_test));
```

We know from reading the description that some of these features represent multiclass data; to facilitate the interpretation, we can use `autotype` from `ScientificTypes`.
By default, `autotype` will check all columns and suggest a Finite type assuming there are relatively few distinct values in the column.
More sophisticated rules can be passed, see [ScientificTypes.jl](https://alan-turing-institute.github.io/ScientificTypes.jl/dev/):

```julia:ex4
datac = coerce(data, autotype(data));
```

Let's see column by column whether it looks ok now

```julia:ex5
sch = schema(datac)
for (name, scitype) in zip(sch.names, sch.scitypes)
    println(rpad("$name", 30), scitype)
end
```

Most columns are now treated as either Multiclass or Ordered, this
corresponds to the [description of the data](https://archive.ics.uci.edu/ml/datasets/Horse+Colic). For instance:

- `Surgery` is described as `1=yes / 2=no`
- `Age` is described as `1=adult / 2=young`

Inspecting the rest of the descriptions and the current scientific type,
there are a few more things that can be observed:

- hospital number is still a count, this means that there are relatively many hospitals and so  that's  probably not very useful,
- pulse and respiratory rate are still as count but the data description suggests that they can be considered as continuous

```julia:ex6
length(unique(datac.hospital_number))
```

yeah let's drop that

```julia:ex7
datac = select!(datac, Not(:hospital_number));
```

let's also coerce the pulse and respiratory rate, in fact we can do that with
`autotype` specifying as rule the `discrete_to_continuous`

```julia:ex8
datac = coerce(datac, autotype(datac, rules=(:discrete_to_continuous,)));
```

### Dealing with missing values

There's quite a lot of missing values, in this tutorial we'll be a bit rough in how we deal with them applying the following rules of thumb:

- drop the rows where the outcome is unknown
- drop columns with more than 20% missing values
- simple imputation of whatever's left

```julia:ex9
missing_outcome = ismissing.(datac.outcome)
idx_missing_outcome = missing_outcome |> findall
```

Ok there's only two row which is nice, let's remove them from the train/test indices and drop the rows

```julia:ex10
train = setdiff!(train |> collect, idx_missing_outcome)
test = setdiff!(test |> collect, idx_missing_outcome)
datac = datac[.!missing_outcome, :];
```

Now let's look at how many missings there are per features

```julia:ex11
for name in names(datac)
    col = datac[:, name]
    ratio_missing = sum(ismissing.(col)) / nrows(datac) * 100
    println(rpad(name, 30), round(ratio_missing, sigdigits=3))
end
```

Let's drop the ones with more than 20% (quite a few!)

```julia:ex12
unwanted = [:peripheral_pulse, :nasogastric_tube, :nasogastric_reflux,
        :nasogastric_reflux_ph, :feces, :abdomen, :abdomcentesis_appearance, :abdomcentesis_total_protein]
select!(datac, Not(unwanted));
```

Note that we could have done this better and investigated the nature of the features for which there's a lot of missing values but don't forget that our goal is to showcase MLJ!

Let's conclude by filling all missing values and separating the feature matrix from the  target

```julia:ex13
@load FillImputer
filler = machine(FillImputer(), datac)
fit!(filler)
datac = transform(filler, datac)

y, X = unpack(datac, ==(:outcome), name->true);
```

## A baseline model

Let's define a first sensible model and get a baseline, basic steps are:
- one-hot-encode the categoricals
- feed all this into a classifier

```julia:ex14
@load OneHotEncoder
@load MultinomialClassifier pkg="MLJLinearModels"
```

Let's have convenient handles over the training data

```julia:ex15
Xtrain = X[train,:]
ytrain = y[train];
```

And let's define a pipeline corresponding to the operations above

```julia:ex16
@pipeline SimplePipe(hot = OneHotEncoder(),
                     clf = MultinomialClassifier()) is_probabilistic=true
mach = machine(SimplePipe(), Xtrain, ytrain)
res = evaluate!(mach; resampling=Holdout(fraction_train=0.9),
                measure=cross_entropy)
round(res.measurement[1], sigdigits=3)
```

This is the cross entropy on some held-out 10% of the training set.
We can also just for the sake of getting a baseline, see the misclassification on the whole training data:

```julia:ex17
ŷ = predict_mode(mach, Xtrain)
mcr = misclassification_rate(ŷ, ytrain)
println(rpad("MNC mcr:", 10), round(mcr, sigdigits=3))
```

That's not bad at all actually.
Let's tune it a bit and see if we can get a bit better than that, not much point in going crazy, we might get a few percents but not much more.

```julia:ex18
model = SimplePipe()
lambdas = range(model, :(clf.lambda), lower=1e-3, upper=100, scale=:log10)
tm = TunedModel(model=SimplePipe(), ranges=lambdas, measure=cross_entropy)
mtm = machine(tm, Xtrain, ytrain)
fit!(mtm)
best_pipe = fitted_params(mtm).best_model
```

So it looks like it's useful to regularise a fair bit to get a lower cross entropy

```julia:ex19
ŷ = predict(mtm, Xtrain)
cross_entropy(ŷ, ytrain) |> mean
```

Interestingly this does not improve our missclassification rate

```julia:ex20
mcr = misclassification_rate(mode.(ŷ), ytrain)
println(rpad("MNC mcr:", 10), round(mcr, sigdigits=3))
```

We've probably reached the limit of a simple linear model.

## Trying another model

There are lots of categoricals, so maybe  it's just better to use something that deals well with that like a tree-based classifier.

```julia:ex21
@load XGBoostClassifier
dtc = machine(XGBoostClassifier(), Xtrain, ytrain)
fit!(dtc)
ŷ = predict(dtc, Xtrain)
cross_entropy(ŷ, ytrain) |> mean
```

So we get a worse cross entropy but...

```julia:ex22
misclassification_rate(mode.(ŷ), ytrain)
```

a significantly better misclassification rate.

We could investigate more, do more tuning etc, but the key points of this tutorial was to show how to handle data with missing values.

