PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────┬───────────┬─────────────┬─────────┬──────────────────────────────────────────────────────┐
│ measure  │ operation │ measurement │ 1.96*SE │ per_fold                                             │
├──────────┼───────────┼─────────────┼─────────┼──────────────────────────────────────────────────────┤
│ LPLoss(  │ predict   │ 0.00729     │ 0.00276 │ [0.00869, 0.0127, 0.0057, 0.00768, 0.00421, 0.00479] │
│   p = 2) │           │             │         │                                                      │
└──────────┴───────────┴─────────────┴─────────┴──────────────────────────────────────────────────────┘
