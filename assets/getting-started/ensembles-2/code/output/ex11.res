PerformanceEvaluation object with these fields:
  model, measure, operation,
  measurement, per_fold, per_observation,
  fitted_params_per_fold, report_per_fold,
  train_test_rows, resampling, repeats
Extract:
┌───┬──────────────────────────────────────┬───────────┬─────────────┐
│   │ measure                              │ operation │ measurement │
├───┼──────────────────────────────────────┼───────────┼─────────────┤
│ A │ RootMeanSquaredError()               │ predict   │ 3.96        │
│ B │ RootMeanSquaredLogProportionalError( │ predict   │ 0.249       │
│   │   offset = 1)                        │           │             │
└───┴──────────────────────────────────────┴───────────┴─────────────┘
