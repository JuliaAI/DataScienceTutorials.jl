# This file was generated, do not modify it. # hide
linear = @load LinearRegressor pkg=MLJLinearModels
knn = @load KNNRegressor; knn.K = 4
tree_booster = @load EvoTreeRegressor; tree_booster.nrounds = 100
forest = @load RandomForestRegressor pkg=DecisionTree; forest.n_trees = 500
svm = @load SVMRegressor;