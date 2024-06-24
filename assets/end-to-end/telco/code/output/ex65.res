PerformanceEvaluation object with these fields:
  model, measure, operation,
  measurement, per_fold, per_observation,
  fitted_params_per_fold, report_per_fold,
  train_test_rows, resampling, repeats
Extract:
┌───┬──────────────────┬──────────────┬─────────────┐
│   │ measure          │ operation    │ measurement │
├───┼──────────────────┼──────────────┼─────────────┤
│ A │ BrierLoss()      │ predict      │ 0.292       │
│ B │ AreaUnderCurve() │ predict      │ 0.822       │
│ C │ Accuracy()       │ predict_mode │ 0.781       │
└───┴──────────────────┴──────────────┴─────────────┘
┌───┬───────────────────────────────────────────────────┬─────────┐
│   │ per_fold                                          │ 1.96*SE │
├───┼───────────────────────────────────────────────────┼─────────┤
│ A │ Float32[0.295, 0.258, 0.321, 0.371, 0.246, 0.261] │ 0.0415  │
│ B │ [0.81, 0.874, 0.786, 0.727, 0.86, 0.873]          │ 0.0514  │
│ C │ [0.795, 0.829, 0.72, 0.72, 0.817, 0.805]          │ 0.0429  │
└───┴───────────────────────────────────────────────────┴─────────┘
