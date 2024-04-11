# This file was generated, do not modify it. # hide
fit!(ŷ, rows=train);
preds = ŷ(rows=test);
rmsl(preds, y[test])