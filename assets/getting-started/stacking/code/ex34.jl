# This file was generated, do not modify it. # hide
avg = MyAverageTwo(regressor1=forest,
                   regressor2=ridge)


stack = MyTwoModelStack(regressor1=forest,
                        regressor2=ridge,
                        judge=linear)

all_models = [forest, ridge, avg, stack];

for model in all_models
    print_performance(model, X, y)
end;