# This file was generated, do not modify it. # hide
Xnew = (Lag1 = [1.2, 1.5], Lag2 = [1.1, -0.8])
ŷ = MLJ.predict(clf, Xnew)
ŷ |> pprint