PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌────────────────────────┬───────────┬─────────────┬─────────┬────────────────────────────────────────────┐
│ measure                │ operation │ measurement │ 1.96*SE │ per_fold                                   │
├────────────────────────┼───────────┼─────────────┼─────────┼────────────────────────────────────────────┤
│ RootMeanSquaredError() │ predict   │ 134.0       │ 7.46    │ [138.0, 118.0, 138.0, 140.0, 139.0, 129.0] │
└────────────────────────┴───────────┴─────────────┴─────────┴────────────────────────────────────────────┘
