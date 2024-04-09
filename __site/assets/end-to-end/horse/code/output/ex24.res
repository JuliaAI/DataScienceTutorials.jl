PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────────────────┬──────────────┬─────────────┬─────────┬─────────────────────────────────────────┐
│ measure              │ operation    │ measurement │ 1.96*SE │ per_fold                                │
├──────────────────────┼──────────────┼─────────────┼─────────┼─────────────────────────────────────────┤
│ LogLoss(             │ predict      │ 0.848       │ 0.106   │ [0.903, 0.699, 0.917, 0.694, 0.9, 0.98] │
│   tol = 2.22045e-16) │              │             │         │                                         │
│ Accuracy()           │ predict_mode │ 0.719       │ 0.0532  │ [0.78, 0.68, 0.7, 0.8, 0.64, 0.714]     │
└──────────────────────┴──────────────┴─────────────┴─────────┴─────────────────────────────────────────┘
