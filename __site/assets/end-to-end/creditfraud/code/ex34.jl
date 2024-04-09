# This file was generated, do not modify it. # hide
SMOTE = @load SMOTE pkg=Imbalance
balanced_model = BalancedModel(model, oversampler=SMOTE())