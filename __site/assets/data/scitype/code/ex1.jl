# This file was generated, do not modify it. # hide
using RDatasets, MLJScientificTypes
boston = dataset("MASS", "Boston")
sch = schema(boston)