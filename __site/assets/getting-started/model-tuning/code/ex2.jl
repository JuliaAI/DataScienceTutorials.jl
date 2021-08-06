# This file was generated, do not modify it. # hide
using MLJ
using PrettyPrinting
MLJ.color_off() # hide
X, y = @load_iris
DecisionTreeClassifier = @load DecisionTreeClassifier pkg=DecisionTree