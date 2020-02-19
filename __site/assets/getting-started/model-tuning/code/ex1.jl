# This file was generated, do not modify it. # hide
using MLJ, PrettyPrinting
MLJ.color_off() # hide
X, y = @load_iris
@load DecisionTreeClassifier