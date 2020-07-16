# This file was generated, do not modify it. # hide
@pipeline HotTreeClf(hot = OneHotEncoder(),
                     tree = DecisionTreeClassifier()) is_probabilistic=true

mdl = HotTreeClf()
mach = machine(mdl, X, y)
fit!(mach);