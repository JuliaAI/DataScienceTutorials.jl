# This file was generated, do not modify it. # hide
lgb = LGBMRegressor() #initialised a model with default params
mach = machine(lgb, features[train, :], targets[train, 1])