PerformanceEvaluation object with these fields:
  model, measure, operation,
  measurement, per_fold, per_observation,
  fitted_params_per_fold, report_per_fold,
  train_test_rows, resampling, repeats
Extract:
┌───┬──────────────────────┬──────────────┬─────────────┐
│   │ measure              │ operation    │ measurement │
├───┼──────────────────────┼──────────────┼─────────────┤
│ A │ LogLoss(             │ predict      │ 0.735       │
│   │   tol = 2.22045e-16) │              │             │
│ B │ Accuracy()           │ predict_mode │ 0.686       │
└───┴──────────────────────┴──────────────┴─────────────┘
┌───┬─────────────────────────────────────────┬─────────┐
│   │ per_fold                                │ 1.96*SE │
├───┼─────────────────────────────────────────┼─────────┤
│ A │ [0.978, 0.566, 0.65, 0.525, 0.91, 0.78] │ 0.162   │
│ B │ [0.62, 0.74, 0.68, 0.72, 0.64, 0.714]   │ 0.0418  │
└───┴─────────────────────────────────────────┴─────────┘
