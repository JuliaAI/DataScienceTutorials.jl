PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────────────┬──────────────┬─────────────┬─────────┬───────────────────────────────────────────────────┐
│ measure          │ operation    │ measurement │ 1.96*SE │ per_fold                                          │
├──────────────────┼──────────────┼─────────────┼─────────┼───────────────────────────────────────────────────┤
│ BrierLoss()      │ predict      │ 0.292       │ 0.0409  │ Float32[0.295, 0.254, 0.316, 0.371, 0.247, 0.266] │
│ AreaUnderCurve() │ predict      │ 0.823       │ 0.0491  │ [0.81, 0.874, 0.802, 0.727, 0.866, 0.861]         │
│ Accuracy()       │ predict_mode │ 0.781       │ 0.046   │ [0.795, 0.829, 0.72, 0.72, 0.841, 0.78]           │
└──────────────────┴──────────────┴─────────────┴─────────┴───────────────────────────────────────────────────┘
