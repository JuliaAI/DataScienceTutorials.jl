# This file was generated, do not modify it. # hide
linear = @load LinearRegressor pkg=MLJLinearModels

ridge = @load RidgeRegressor pkg=MultivariateStats
ridge.lambda = 0.01

knn = @load KNNRegressor; knn.K = 4

tree = @load DecisionTreeRegressor; min_samples_leaf=1
forest = @load RandomForestRegressor pkg=DecisionTree
forest.n_trees=500

svm = @load SVMRegressor;