# This file was generated, do not modify it. # hide
using MLJ, RDatasets, ScientificTypes,
      DataFrames, Statistics, StatsBase
using MLJ: confusion_matrix, accuracy, tp, fp,
      precision, recall, auc, roc, f1score
using PrettyPrinting

smarket = dataset("ISLR", "Smarket")
@show size(smarket)
@show names(smarket)