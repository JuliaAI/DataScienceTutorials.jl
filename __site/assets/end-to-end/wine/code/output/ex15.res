PerformanceEvaluation object with these fields:
  model, measure, operation,
  measurement, per_fold, per_observation,
  fitted_params_per_fold, report_per_fold,
  train_test_rows, resampling, repeats
Extract:
┌───┬──────────────────────┬──────────────┬─────────────┐
│   │ measure              │ operation    │ measurement │
├───┼──────────────────────┼──────────────┼─────────────┤
│ A │ LogLoss(             │ predict      │ 3.3e-6      │
│   │   tol = 2.22045e-16) │              │             │
│ B │ Accuracy()           │ predict_mode │ 1.0         │
└───┴──────────────────────┴──────────────┴─────────────┘
