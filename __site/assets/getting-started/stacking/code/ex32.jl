# This file was generated, do not modify it. # hide
avg = MyAverageTwo(regressor1=tree_booster,
                   regressor2=svm)


stack = MyTwoModelStack(regressor1=tree_booster,
                        regressor2=svm,
                        judge=forest) # judge=linear

all_models = [tree_booster, svm, forest, avg, stack];

for model in all_models
    print_performance(model, X, y)
end