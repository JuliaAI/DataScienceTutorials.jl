PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────────────────┬──────────────┬─────────────┬─────────┬───────────────────────────────────────────┐
│ measure              │ operation    │ measurement │ 1.96*SE │ per_fold                                  │
├──────────────────────┼──────────────┼─────────────┼─────────┼───────────────────────────────────────────┤
│ LogLoss(             │ predict      │ 0.706       │ 0.111   │ [0.798, 0.63, 0.638, 0.528, 0.866, 0.774] │
│   tol = 2.22045e-16) │              │             │         │                                           │
│ Accuracy()           │ predict_mode │ 0.686       │ 0.0317  │ [0.68, 0.7, 0.7, 0.74, 0.64, 0.653]       │
└──────────────────────┴──────────────┴─────────────┴─────────┴───────────────────────────────────────────┘
