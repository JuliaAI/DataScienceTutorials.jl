# This file was generated, do not modify it. # hide
folds(X::AbstractNode, nfolds) = node(XX->folds(XX, nfolds), X)
f = folds(X, 3)
f()