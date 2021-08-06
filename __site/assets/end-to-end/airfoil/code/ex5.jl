# This file was generated, do not modify it. # hide
X = MLJ.transform(fit!(machine(Standardizer(), X)), X);