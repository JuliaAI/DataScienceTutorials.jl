# This file was generated, do not modify it. # hide
pred_rfr = predict(rfr_m, rows=test);
rms(pred_rfr, y[test])