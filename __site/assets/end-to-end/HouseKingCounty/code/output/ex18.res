PerformanceEvaluation object with these fields:
  model, measure, operation,
  measurement, per_fold, per_observation,
  fitted_params_per_fold, report_per_fold,
  train_test_rows, resampling, repeats
Extract:
┌────────────────────────┬───────────┬─────────────┐
│ measure                │ operation │ measurement │
├────────────────────────┼───────────┼─────────────┤
│ RootMeanSquaredError() │ predict   │ 136.0       │
└────────────────────────┴───────────┴─────────────┘
┌────────────────────────────────────────────┬─────────┐
│ per_fold                                   │ 1.96*SE │
├────────────────────────────────────────────┼─────────┤
│ [135.0, 132.0, 130.0, 138.0, 135.0, 145.0] │ 4.37    │
└────────────────────────────────────────────┴─────────┘
