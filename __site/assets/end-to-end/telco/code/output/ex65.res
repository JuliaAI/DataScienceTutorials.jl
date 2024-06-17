PerformanceEvaluation object with these fields:
  model, measure, operation,
  measurement, per_fold, per_observation,
  fitted_params_per_fold, report_per_fold,
  train_test_rows, resampling, repeats
Extract:
┌───┬──────────────────┬──────────────┬─────────────┐
│   │ measure          │ operation    │ measurement │
├───┼──────────────────┼──────────────┼─────────────┤
│ A │ BrierLoss()      │ predict      │ 0.287       │
│ B │ AreaUnderCurve() │ predict      │ 0.839       │
│ C │ Accuracy()       │ predict_mode │ 0.791       │
└───┴──────────────────┴──────────────┴─────────────┘
┌───┬───────────────────────────────────────────────────┬─────────┐
│   │ per_fold                                          │ 1.96*SE │
├───┼───────────────────────────────────────────────────┼─────────┤
│ A │ Float32[0.289, 0.254, 0.308, 0.356, 0.252, 0.265] │ 0.0351  │
│ B │ [0.836, 0.874, 0.822, 0.757, 0.876, 0.869]        │ 0.0403  │
│ C │ [0.759, 0.829, 0.793, 0.744, 0.817, 0.805]        │ 0.0293  │
└───┴───────────────────────────────────────────────────┴─────────┘
