# Before running this, please make sure to activate and instantiate the
# tutorial-specific package environment, using this
# [`Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/end-to-end/horse/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/end-to-end/horse/Manifest.toml), or by following
# [these](https://juliaai.github.io/DataScienceTutorials.jl/#learning_by_doing) detailed instructions.

# @@dropdown
# ## Initial data processing
# @@
# @@dropdown-content
#
# In this example, we consider the [UCI "horse colic"
# dataset](http://archive.ics.uci.edu/ml/datasets/Horse+Colic)
#
# This is a reasonably messy classification problem with missing values etc and so some
# work should be expected in the feature processing.

# @@dropdown
# ### Getting the data
# @@
# @@dropdown-content
#
# The data is pre-split in training and testing and we will keep it as such

using MLJ
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

# ‎
# @@
# @@dropdown
# ### Inspecting columns
# @@
# @@dropdown-content
#
# To simplify the analysis, we will drop the columns `Lesion *` as they would need
# specific re-encoding which would distract us a bit.

unwanted = [:lesion_1, :lesion_2, :lesion_3]
data = vcat(data_train, data_test)
select!(data, Not(unwanted));

# Let's also keep track of the initial train-test split

train = 1:nrows(data_train)
test = last(train) .+ (1:nrows(data_test));

# We know from reading the description that some of these features represent multiclass
# data; to facilitate the interpretation, we can use `autotype` from `ScientificTypes`.
# By default, `autotype` will check all columns and suggest a Finite type assuming there
# are relatively few distinct values in the column.  More sophisticated rules can be
# passed, see
# [ScientificTypes.jl](https://alan-turing-institute.github.io/ScientificTypes.jl/dev/):

coerce!(data, autotype(data));

# Let's see column by column whether it looks ok now

schema(data)

# Most columns are now treated as either Multiclass or Ordered, this corresponds to the
# [description of the data](https://archive.ics.uci.edu/ml/datasets/Horse+Colic). For
# instance:
#
# - `Surgery` is described as `1=yes / 2=no`
# - `Age` is described as `1=adult / 2=young`
#
# Inspecting the rest of the descriptions and the current scientific type,
# there are a few more things that can be observed:
#
# - hospital number is still a count, this means that there are relatively many hospitals and so  that's  probably not very useful,
# - pulse and respiratory rate are still as count but the data description suggests that they can be considered as continuous

length(unique(data.hospital_number))

# yeah let's drop that

data = select!(data, Not(:hospital_number));

# let's also coerce the pulse and respiratory rate, by coercing all remaining `Count`
# features to `Continuous`:

coerce!(data, Count => Continuous)
schema(data)

# ‎
# @@
# @@dropdown
# ### Dealing with missing values
# @@
# @@dropdown-content
#
# There's quite a lot of missing values, in this tutorial we'll be a bit rough in how we deal with them applying the following rules of thumb:
#
# - drop the rows where the outcome is unknown
# - drop columns with more than 20% missing values
# - simple imputation of whatever's left

missing_outcome = ismissing.(data.outcome)
idx_missing_outcome = missing_outcome |> findall

# Ok there's only two row which is nice, let's remove them from the train/test indices:

train = setdiff!(train |> collect, idx_missing_outcome)
test = setdiff!(test |> collect, idx_missing_outcome)
all = vcat(train, test);

# Now let's look at how many missings there are per features

for name in names(data)
    col = data[all, name]
    ratio_missing = sum(ismissing.(col)) / length(all) * 100
    println(rpad(name, 30), round(ratio_missing, sigdigits=3))
end

# Let's drop the ones with more than 20% (quite a few!)

unwanted = [:peripheral_pulse, :nasogastric_tube, :nasogastric_reflux,
            :nasogastric_reflux_ph, :feces, :abdomen,
            :abdomcentesis_appearance, :abdomcentesis_total_protein]
select!(data, Not(unwanted));

# Note that we could have done this better and investigated the nature of the features for
# which there's a lot of missing values but don't forget that our goal is to showcase MLJ!
#
# Let's conclude by filling all missing values and separating the features from the target:

@load FillImputer
filler = machine(FillImputer(), data[all, :]) |> fit!
data = MLJ.transform(filler, data)

y, X = unpack(data, ==(:outcome)); # a vector and a table

# ‎
# @@

# ‎
# @@
# @@dropdown
# ## A baseline model
# @@
# @@dropdown-content
#
# Let's define a first sensible model and get a baseline, basic steps are:
# - one-hot-encode the categoricals
# - feed all this into a classifier

@load OneHotEncoder
MultinomialClassifier = @load MultinomialClassifier pkg="MLJLinearModels"

# Let's have convenient handles over the training data

Xtrain = X[train,:]
ytrain = y[train];

# And let's define a pipeline corresponding to the operations above

pipe = OneHotEncoder() |>  MultinomialClassifier()

# Here are log loss and accuracy estimates of model performance, obtained by training
# on 90% of the `train` data, and computing the measures on the remaining 10%:

metrics = [log_loss, accuracy]
evaluate(
    pipe, Xtrain, ytrain;
    resampling = Holdout(fraction_train=0.9),
    measures = metrics,
)

# If we perform cross-validation instead, we also get a very rough idea of the
# uncertainties in our estimates ("SE" is "standard error"):

evaluate(pipe, Xtrain, ytrain; resampling=CV(nfolds=6), measures=metrics)

# And for a final comparison, here's how we do on the test set, which we have not yet
# touched:

mach = machine(pipe, Xtrain, ytrain) |> fit!
fit!(mach, verbosity=0)
yhat_prob = predict(mach, X[test,:])
m = log_loss(yhat_prob, y[test])
println("log loss: ", round(m, sigdigits=4))

yhat = mode.(yhat_prob)
m = accuracy(yhat, y[test])
println("accuracy: ", round(m, sigdigits=4))

# That's not bad at all actually.

# Since our data set is relatively small, we do not expect a statistically significant
# improvement with hyperparameter tuning. However, for the sake of illustration we'll
# attempt this.

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

# So, not likely a statistically significant difference. Nevertheless, let's see how we do
# with accuracy on a holdout set:

fit!(mach) # fit on all the train data
yhat = predict_mode(mach, X[test,:])
m = accuracy(yhat, y[test])
println("accuracy: ", round(m, sigdigits=4))

# So an improvement after all on the test set.

# We've probably reached the limit of a simple linear model.

# ‎
# @@
# @@dropdown
# ## Trying another model
# @@
# @@dropdown-content
#
# There are lots of categoricals, so maybe it's just better to use something that deals
# well with that like a tree-based classifier.

EvoTreeClassifier = @load EvoTreeClassifier
model = EvoTreeClassifier()
mach = machine(model, Xtrain, ytrain)
evaluate!(mach; resampling=CV(nfolds=6), measures=metrics)

# That's better accuracy, although not significantly better, than the other CV estimates
# based on `train`, and without any tuning. Do we actually do better on the `test` set?

fit!(mach) # fit on all the train data
yhat = predict_mode(mach, X[test,:])
m = accuracy(yhat, y[test])
println("accuracy: ", round(m, sigdigits=4))

# So, the best so far.

# We could investigate more, try tuning etc, but the key points of this tutorial was to
# show how to handle data with missing values.

# ‎
# @@

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
