# ## Getting started
#
# ### Loading and  preparing the data

using MLJ, PrettyPrinting, DataFrames, Statistics, CSV
using PyPlot, HTTP

MLJ.color_off() # hide

req = HTTP.get("https://raw.githubusercontent.com/rupakc/UCI-Data-Analysis/master/Airfoil%20Dataset/airfoil_self_noise.dat");

df = CSV.read(req.body, header=[
                  "Frequency","Attack_Angle","Chord+Length","Free_Velocity","Suction_Side","Scaled_Sound"
              ]
       );
df[1:5, :] |> pretty

# We load the RandomForestRegressor from ScikitLearn
rfr = @load RandomForestRegressor pkg=ScikitLearn

#-unpack into the data and labels
y, X = unpack(df, ==(:Scaled_Sound), col -> true);

# Partition into train and test set
train, test = partition(eachindex(y), 0.7);

rfr = RandomForestRegressor();

rfr_m = machine(rfr, X, y);

# train on the rows corresponding to train
fit!(rfr_m, rows=train);

# predict values on the rows corresponding to test
pred = MLJ.predict(rfr_m, rows=test);
pred[1:5]
