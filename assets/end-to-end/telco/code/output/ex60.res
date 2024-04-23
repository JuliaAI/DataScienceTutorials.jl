PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────────────┬──────────────┬─────────────┬─────────┬───────────────────────────────────────────────────┐
│ measure          │ operation    │ measurement │ 1.96*SE │ per_fold                                          │
├──────────────────┼──────────────┼─────────────┼─────────┼───────────────────────────────────────────────────┤
│ BrierLoss()      │ predict      │ 0.278       │ 0.0195  │ Float32[0.245, 0.294, 0.293, 0.278, 0.259, 0.301] │
│ AreaUnderCurve() │ predict      │ 0.836       │ 0.0214  │ [0.87, 0.814, 0.818, 0.833, 0.862, 0.818]         │
│ Accuracy()       │ predict_mode │ 0.789       │ 0.0261  │ [0.807, 0.744, 0.793, 0.793, 0.829, 0.768]        │
└──────────────────┴──────────────┴─────────────┴─────────┴───────────────────────────────────────────────────┘
