# This file was generated, do not modify it. # hide
tree = machine(DecisionTreeRegressor(), X, y)
e = evaluate!(tree, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e |> pprint