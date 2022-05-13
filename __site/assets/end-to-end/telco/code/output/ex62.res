PerformanceEvaluation object with these fields:
  measure, measurement, operation, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows
Extract:
┌──────────────────┬─────────────┬──────────────┬────────────────────────────────────────────┐
│ measure          │ measurement │ operation    │ per_fold                                   │
├──────────────────┼─────────────┼──────────────┼────────────────────────────────────────────┤
│ BrierLoss()      │ 0.293       │ predict      │ [0.297, 0.334, 0.265, 0.278, 0.322, 0.26]  │
│ AreaUnderCurve() │ 0.816       │ predict      │ [0.804, 0.749, 0.823, 0.858, 0.772, 0.892] │
│ Accuracy()       │ 0.801       │ predict_mode │ [0.807, 0.793, 0.841, 0.793, 0.768, 0.805] │
└──────────────────┴─────────────┴──────────────┴────────────────────────────────────────────┘
