CompactPerformanceEvaluation object with these fields:
  model, measure, operation,
  measurement, per_fold, per_observation,
  train_test_rows, resampling, repeats
Extract:
┌───┬──────────────────┬──────────────┬─────────────┐
│   │ measure          │ operation    │ measurement │
├───┼──────────────────┼──────────────┼─────────────┤
│ A │ BrierLoss()      │ predict      │ 0.286       │
│ B │ AreaUnderCurve() │ predict      │ 0.82        │
│ C │ Accuracy()       │ predict_mode │ 0.801       │
└───┴──────────────────┴──────────────┴─────────────┘
┌───┬───────────────────────────────────────────────┬─────────┐
│   │ per_fold                                      │ 1.96*SE │
├───┼───────────────────────────────────────────────┼─────────┤
│ A │ Float32[0.312, 0.3, 0.282, 0.235, 0.3, 0.289] │ 0.024   │
│ B │ [0.769, 0.798, 0.829, 0.894, 0.798, 0.834]    │ 0.0379  │
│ C │ [0.783, 0.817, 0.793, 0.854, 0.756, 0.805]    │ 0.0289  │
└───┴───────────────────────────────────────────────┴─────────┘
