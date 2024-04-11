PerformanceEvaluation object with these fields:
  model, measure, operation, measurement, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows, resampling, repeats
Extract:
┌──────────────────┬──────────────┬─────────────┬─────────┬─────────────────────────────────────────────────┐
│ measure          │ operation    │ measurement │ 1.96*SE │ per_fold                                        │
├──────────────────┼──────────────┼─────────────┼─────────┼─────────────────────────────────────────────────┤
│ BrierLoss()      │ predict      │ 0.28        │ 0.0166  │ Float32[0.252, 0.296, 0.289, 0.281, 0.263, 0.3] │
│ AreaUnderCurve() │ predict      │ 0.834       │ 0.017   │ [0.862, 0.811, 0.82, 0.834, 0.851, 0.825]       │
│ Accuracy()       │ predict_mode │ 0.789       │ 0.0297  │ [0.831, 0.744, 0.793, 0.793, 0.817, 0.756]      │
└──────────────────┴──────────────┴─────────────┴─────────┴─────────────────────────────────────────────────┘
