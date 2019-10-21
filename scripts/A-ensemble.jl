# ## Preliminary steps
#
# Let's start by loading the relevant packages and generating some dummy data.

using MLJ, DataFrames, Statistics

Xraw = rand(300, 3)
y = exp.(Xraw[:,1] - Xraw[:,2] - 2Xraw[:,3] + 0.1*rand(300))
X = DataFrame(Xraw)

train, test = partition(eachindex(y), 0.7);

# Let's also load a simple model:

@load KNNRegressor

#
# ### Basic training and testing
#
# ## Homogenous ensembles
#
# ## Systematic tuning
#
# ### Reporting results
