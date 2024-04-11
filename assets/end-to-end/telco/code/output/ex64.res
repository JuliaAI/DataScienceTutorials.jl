PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────────────┬──────────────┬─────────────┬─────────┬───────────────────────────────────────────────────┐
│ measure          │ operation    │ measurement │ 1.96*SE │ per_fold                                          │
├──────────────────┼──────────────┼─────────────┼─────────┼───────────────────────────────────────────────────┤
│ BrierLoss()      │ predict      │ 0.295       │ 0.0404  │ Float32[0.295, 0.258, 0.325, 0.371, 0.252, 0.266] │
│ AreaUnderCurve() │ predict      │ 0.825       │ 0.0507  │ [0.81, 0.874, 0.803, 0.727, 0.878, 0.861]         │
│ Accuracy()       │ predict_mode │ 0.781       │ 0.034   │ [0.795, 0.829, 0.756, 0.72, 0.805, 0.78]          │
└──────────────────┴──────────────┴─────────────┴─────────┴───────────────────────────────────────────────────┘
