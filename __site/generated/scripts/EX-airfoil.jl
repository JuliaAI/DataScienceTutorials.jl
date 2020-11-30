# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# **Main author**: [Ashrya Agrawal](https://github.com/ashryaagr).## ## Getting started# Here we use the [UCI "Airfoil Self-Noise" dataset](http://archive.ics.uci.edu/ml/datasets/Airfoil+Self-Noise)# ### Loading and  preparing the data
using MLJ
using PrettyPrinting
import DataFrames
import Statistics
using CSV
using PyPlot

using HTTP
using StableRNGs



req = HTTP.get("https://raw.githubusercontent.com/rupakc/UCI-Data-Analysis/master/Airfoil%20Dataset/airfoil_self_noise.dat");

df = CSV.read(req.body; header=[
                  "Frequency","Attack_Angle","Chord+Length",
                  "Free_Velocity","Suction_Side","Scaled_Sound"
              ]
       );
df[1:5, :] |> pretty

# inspect the schema:
schema(df)

# unpack into the data and labels:
y, X = unpack(df, ==(:Scaled_Sound), col -> true);

# Now we Standardize the features using the transformer Standardizer()
X = transform(fit!(machine(Standardizer(), X)), X);

# Partition into train and test set
train, test = partition(eachindex(y), 0.7, shuffle=true, rng=StableRNG(612));

# Let's first see which models are compatible with the scientific type and machine type of our data
for model in models(matching(X, y))
       print("Model Name: " , model.name , " , Package: " , model.package_name , "\n")
end

# Note that if we coerce `X.Frequency` to `Continuous`, many more models are available:
coerce!(X, :Frequency=>Continuous)

for model in models(matching(X, y))
       print("Model Name: " , model.name , " , Package: " , model.package_name , "\n")
end

# ## DecisionTreeRegressor## We will first try out DecisionTreeRegressor:
dcr = @load DecisionTreeRegressor pkg=DecisionTree

dcrm = machine(dcr, X, y)

fit!(dcrm, rows=train)
pred_dcrm = MLJ.predict(dcrm, rows=test);

# Now you can call a loss function to assess the performance on test set.
rms(pred_dcrm, y[test])

# ## RandomForestRegressor## Now let's try out RandomForestRegressor:
rfr = @load RandomForestRegressor pkg=DecisionTree

rfr_m = machine(rfr, X, y);

# train on the rows corresponding to train
fit!(rfr_m, rows=train);

# predict values on the rows corresponding to test
pred_rfr = MLJ.predict(rfr_m, rows=test);
rms(pred_rfr, y[test])

# Unsurprisingly, the RandomForestRegressor does a better job.## Can we do even better? Yeah, we can!! We can make use of Model Tuning.## ## Tuning## In case you are new to model tuning using MLJ, refer [lab5](https://alan-turing-institute.github.io/DataScienceTutorials.jl/isl/lab-5/) and [model-tuning](https://alan-turing-institute.github.io/DataScienceTutorials.jl/getting-started/model-tuning/)## Range of values for parameters should be specified to do hyperparameter tuning
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
pred_rfr_tm = MLJ.predict(rfr_tm, rows=test);
rms(pred_rfr_tm, y[test])

# That was great! We have further improved the accuracy## Now to retrieve best model, You can use
fitted_params(rfr_tm).best_model

# Now we can investigate the tuning by using report.# Let's plot a heatmap of the measurements:
r = report(rfr_tm)
res = r.plotting

md = res.parameter_values[:,1]
mcw = res.parameter_values[:,2]

figure(figsize=(8,6))
tricontourf(md, mcw, res.measurements)

xlabel("Number of trees", fontsize=14)
ylabel("Sampling fraction", fontsize=14)
xticks(9:1:15, fontsize=12)
yticks(fontsize=12)


# \figalt{Hyperparameter heatmap}{airfoil_heatmap.svg}


# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

