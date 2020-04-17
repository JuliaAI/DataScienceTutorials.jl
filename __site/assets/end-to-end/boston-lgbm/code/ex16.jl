# This file was generated, do not modify it. # hide
pred_rfr_tm = MLJ.predict(rfr_tm, rows=test);
rms(pred_rfr_tm, y[test])