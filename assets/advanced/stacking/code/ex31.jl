# This file was generated, do not modify it. # hide
avg = MyAverageTwo(tree_booster,svm)
stack = MyTwoModelStack(model1=tree_booster, model2=svm, judge=forest)
all_models = [tree_booster, svm, forest, avg, stack];

for model in all_models
    print_performance(model, X, y)
end