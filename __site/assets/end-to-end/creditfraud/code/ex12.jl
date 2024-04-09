# This file was generated, do not modify it. # hide
reduction = 0.05
frac_train = 0.8*reduction
frac_test = 0.2*reduction

y, X = unpack(data, ==(:Class))
(Xtrain, Xtest, _), (ytrain, ytest, _) =
    partition((X, y), frac_train, frac_test; stratify=y, multi=true, rng=111);

StatsBase.countmap(ytrain)