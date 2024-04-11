PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────────────┬──────────────┬─────────────┬─────────┬───────────────────────────────────────────────────┐
│ measure          │ operation    │ measurement │ 1.96*SE │ per_fold                                          │
├──────────────────┼──────────────┼─────────────┼─────────┼───────────────────────────────────────────────────┤
│ BrierLoss()      │ predict      │ 0.285       │ 0.0268  │ Float32[0.271, 0.278, 0.282, 0.337, 0.298, 0.246] │
│ AreaUnderCurve() │ predict      │ 0.836       │ 0.0404  │ [0.854, 0.837, 0.837, 0.781, 0.794, 0.91]         │
│ Accuracy()       │ predict_mode │ 0.789       │ 0.026   │ [0.795, 0.793, 0.793, 0.732, 0.805, 0.817]        │
└──────────────────┴──────────────┴─────────────┴─────────┴───────────────────────────────────────────────────┘
