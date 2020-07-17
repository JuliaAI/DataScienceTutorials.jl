# This file was generated, do not modify it. # hide
HotTreeClf = @pipeline(OneHotEncoder(),
                       DecisionTreeClassifier())

mdl = HotTreeClf
mach = machine(mdl, X, y)
fit!(mach);