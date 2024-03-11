using Pkg# hideall
Pkg.activate("_literate/EX-airfoil/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

# **Main author**: [Ashrya Agrawal](https://github.com/ashryaagr).
#

# @@dropdown
# ## Getting started
# @@
# @@dropdown-content
# Here we use the [UCI "Airfoil Self-Noise" dataset](http://archive.ics.uci.edu/ml/datasets/Airfoil+Self-Noise)

# @@dropdown
# ### Loading and  preparing the data
# @@
# @@dropdown-content

using MLJ
using PrettyPrinting
import DataFrames
import Statistics
using CSV
using HTTP
using StableRNGs

MLJ.color_off() # hide

req = HTTP.get("https://raw.githubusercontent.com/rupakc/UCI-Data-Analysis/master/Airfoil%20Dataset/airfoil_self_noise.dat");

df = CSV.read(req.body, DataFrames.DataFrame; header=[
                   "Frequency","Attack_Angle","Chord+Length",
                   "Free_Velocity","Suction_Side","Scaled_Sound"
                   ]
              );
df[1:5, :] |> pretty

# inspect the schema:

schema(df)

# unpack into the data and labels:

y, X = unpack(df, ==(:Scaled_Sound));

# Now we Standardize the features using the transformer Standardizer()

X = MLJ.transform(fit!(machine(Standardizer(), X)), X);

# Partition into train and test set

train, test = partition(collect(eachindex(y)), 0.7, shuffle=true, rng=StableRNG(612));

# Let's first see which models are compatible with the scientific type and machine type of our data

for model in models(matching(X, y))
       print("Model Name: " , model.name , " , Package: " , model.package_name , "\n")
end

# Note that if we coerce `X.Frequency` to `Continuous`, many more models are available:

coerce!(X, :Frequency=>Continuous)

for model in models(matching(X, y))
       print("Model Name: " , model.name , " , Package: " , model.package_name , "\n")
end


# ‎
# @@

# ‎
# @@
# @@dropdown
# ## DecisionTreeRegressor
# @@
# @@dropdown-content
#
# We will first try out DecisionTreeRegressor:

DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree

dcrm = machine(DecisionTreeRegressor(), X, y)

fit!(dcrm, rows=train)
pred_dcrm = predict(dcrm, rows=test);

# Now you can call a loss function to assess the performance on test set.

rms(pred_dcrm, y[test])


# ‎
# @@
# @@dropdown
# ## RandomForestRegressor
# @@
# @@dropdown-content
#
# Now let's try out RandomForestRegressor:

RandomForestRegressor = @load RandomForestRegressor pkg=DecisionTree
rfr = RandomForestRegressor()

rfr_m = machine(rfr, X, y);

# train on the rows corresponding to train

fit!(rfr_m, rows=train);

# predict values on the rows corresponding to test

pred_rfr = predict(rfr_m, rows=test);
rms(pred_rfr, y[test])

# Unsurprisingly, the RandomForestRegressor does a better job.
#
# Can we do even better? Yeah, we can!! We can make use of Model Tuning.
#

# ‎
# @@
# @@dropdown
# ## Tuning
# @@
# @@dropdown-content
#
# In case you are new to model tuning using MLJ, refer [lab5](https://alan-turing-institute.github.io/DataScienceTutorials.jl/isl/lab-5/) and [model-tuning](https://alan-turing-institute.github.io/DataScienceTutorials.jl/getting-started/model-tuning/)
#
# Range of values for parameters should be specified to do hyperparameter tuning

r_maxD = range(rfr, :n_trees, lower=9, upper=15)
r_samF = range(rfr, :sampling_fraction, lower=0.6, upper=0.8)
r = [r_maxD, r_samF];

# Now we specify how the tuning should be done. Let's just specify a coarse grid tuning with cross validation and instantiate a tuned model:

tuning = Grid(resolution=7)
resampling = CV(nfolds=6)

tm = TunedModel(model=rfr, tuning=tuning,
                resampling=resampling, ranges=r, measure=rms)

rfr_tm = machine(tm, X, y);

# train on the rows corresponding to train

fit!(rfr_tm, rows=train);

# predict values on the rows corresponding to test

pred_rfr_tm = predict(rfr_tm, rows=test);
rms(pred_rfr_tm, y[test])

# That was great! We have further improved the accuracy
#
# Now to retrieve best model, You can use

fitted_params(rfr_tm).best_model

# Let's visualize the tuning results:

plot(rfr_tm)

savefig(joinpath(@OUTPUT, "airfoil_heatmap.svg")) # hide

# \figalt{Hyperparameter heatmap}{airfoil_heatmap.svg}


# ‎
# @@
