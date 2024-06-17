PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌────────────────────────┬───────────┬─────────────┬─────────┬────────────────────────────────────────────┐
│ measure                │ operation │ measurement │ 1.96*SE │ per_fold                                   │
├────────────────────────┼───────────┼─────────────┼─────────┼────────────────────────────────────────────┤
│ RootMeanSquaredError() │ predict   │ 137.0       │ 4.46    │ [136.0, 134.0, 130.0, 139.0, 135.0, 145.0] │
└────────────────────────┴───────────┴─────────────┴─────────┴────────────────────────────────────────────┘
