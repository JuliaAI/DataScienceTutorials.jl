# This file was generated, do not modify it. # hide
train, test = partition(eachindex(yc), 0.8, shuffle=true, rng=111);
Xtrain = selectrows(Xcs, train)
Xtest = selectrows(Xcs, test)
ytrain = selectrows(yc, train)
ytest = selectrows(yc, test);