PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────────────┬──────────────┬─────────────┬─────────┬─────────────────────────────────────────────────┐
│ measure          │ operation    │ measurement │ 1.96*SE │ per_fold                                        │
├──────────────────┼──────────────┼─────────────┼─────────┼─────────────────────────────────────────────────┤
│ BrierLoss()      │ predict      │ 0.294       │ 0.0394  │ Float32[0.3, 0.256, 0.325, 0.365, 0.252, 0.264] │
│ AreaUnderCurve() │ predict      │ 0.829       │ 0.0507  │ [0.819, 0.879, 0.803, 0.73, 0.876, 0.867]       │
│ Accuracy()       │ predict_mode │ 0.785       │ 0.0334  │ [0.771, 0.829, 0.756, 0.732, 0.817, 0.805]      │
└──────────────────┴──────────────┴─────────────┴─────────┴─────────────────────────────────────────────────┘
