# This file was generated, do not modify it. # hide
(Xtrain, Xtest), (ytrain, ytest) =
    partition((Xc, yc), 0.8, rng=StableRNG(123), multi=true);