# This file was generated, do not modify it. # hide
folds(X::AbstractNode, nfolds) = node(XX -> folds(XX, nfolds), X);