# This file was generated, do not modify it. # hide
RandomForestRegressor = @load RandomForestRegressor pkg=DecisionTree
rfr = RandomForestRegressor()

rfr_m = machine(rfr, X, y);