PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────┬───────────┬─────────────┬─────────┬─────────────────────────────────────────────────────┐
│ measure  │ operation │ measurement │ 1.96*SE │ per_fold                                            │
├──────────┼───────────┼─────────────┼─────────┼─────────────────────────────────────────────────────┤
│ LPLoss(  │ predict   │ 0.00735     │ 0.00285 │ [0.0085, 0.0131, 0.00548, 0.00777, 0.00457, 0.0047] │
│   p = 2) │           │             │         │                                                     │
└──────────┴───────────┴─────────────┴─────────┴─────────────────────────────────────────────────────┘
