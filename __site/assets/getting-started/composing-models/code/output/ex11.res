PerformanceEvaluation object with these fields:
  model, measure, operation,
  measurement, per_fold, per_observation,
  fitted_params_per_fold, report_per_fold,
  train_test_rows, resampling, repeats
Extract:
┌──────────┬───────────┬─────────────┐
│ measure  │ operation │ measurement │
├──────────┼───────────┼─────────────┤
│ LPLoss(  │ predict   │ 187.0       │
│   p = 1) │           │             │
└──────────┴───────────┴─────────────┘
┌───────────────────────┬─────────┐
│ per_fold              │ 1.96*SE │
├───────────────────────┼─────────┤
│ [168.0, 141.0, 314.0] │ 129.0   │
└───────────────────────┴─────────┘
