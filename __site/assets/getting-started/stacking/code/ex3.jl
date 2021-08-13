# This file was generated, do not modify it. # hide
linear = (@load LinearRegressor pkg=MLJLinearModels)()
knn = (@load KNNRegressor)()

tree_booster = (@load EvoTreeRegressor)()
forest = (@load RandomForestRegressor pkg=DecisionTree)()
svm = (@load SVMRegressor)()