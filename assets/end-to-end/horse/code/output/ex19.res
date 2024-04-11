PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────────────────┬──────────────┬─────────────┬─────────┬─────────────────────────────────────────┐
│ measure              │ operation    │ measurement │ 1.96*SE │ per_fold                                │
├──────────────────────┼──────────────┼─────────────┼─────────┼─────────────────────────────────────────┤
│ LogLoss(             │ predict      │ 0.735       │ 0.162   │ [0.978, 0.566, 0.65, 0.525, 0.91, 0.78] │
│   tol = 2.22045e-16) │              │             │         │                                         │
│ Accuracy()           │ predict_mode │ 0.686       │ 0.0418  │ [0.62, 0.74, 0.68, 0.72, 0.64, 0.714]   │
└──────────────────────┴──────────────┴─────────────┴─────────┴─────────────────────────────────────────┘
