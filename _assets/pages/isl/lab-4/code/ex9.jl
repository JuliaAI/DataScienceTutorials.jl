# This file was generated, do not modify it. # hide
@load LogisticClassifier pkg=MLJLinearModels
X2 = select(X, Not([:Year, :Today]))
clf = machine(LogisticClassifier(), X2, y)