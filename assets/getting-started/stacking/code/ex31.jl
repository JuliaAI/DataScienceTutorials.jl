# This file was generated, do not modify it. # hide
hot_mach = fit!(machine(OneHotEncoder(), X1), verbosity=0)
X = transform(hot_mach, X1);