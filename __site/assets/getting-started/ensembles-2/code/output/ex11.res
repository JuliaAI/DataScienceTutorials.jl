PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────────────────────────────────┬───────────┬─────────────┬──────────┐
│ measure                              │ operation │ measurement │ per_fold │
├──────────────────────────────────────┼───────────┼─────────────┼──────────┤
│ RootMeanSquaredError()               │ predict   │ 3.94        │ [3.94]   │
│ RootMeanSquaredLogProportionalError( │ predict   │ 0.252       │ [0.252]  │
│   offset = 1)                        │           │             │          │
└──────────────────────────────────────┴───────────┴─────────────┴──────────┘
