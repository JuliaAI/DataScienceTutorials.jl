# This file was generated, do not modify it. # hide
DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree
forest = EnsembleModel(model=DecisionTreeRegressor())