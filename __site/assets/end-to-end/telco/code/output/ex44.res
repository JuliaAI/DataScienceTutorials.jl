PerformanceEvaluation object with these fields:
  measure, measurement, operation, per_fold,
  per_observation, fitted_params_per_fold,
  report_per_fold, train_test_rows
Extract:
┌──────────────────┬─────────────┬──────────────┬────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ measure          │ measurement │ operation    │ per_fold                                                                                                                       │
├──────────────────┼─────────────┼──────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ BrierLoss()      │ 0.313       │ predict      │ [0.311, 0.344, 0.291, 0.348, 0.357, 0.295, 0.285, 0.313, 0.324, 0.296, 0.284, 0.343, 0.316, 0.268, 0.306, 0.369, 0.287, 0.298] │
│ AreaUnderCurve() │ 0.788       │ predict      │ [0.778, 0.743, 0.802, 0.774, 0.724, 0.808, 0.832, 0.788, 0.743, 0.82, 0.862, 0.692, 0.761, 0.845, 0.827, 0.734, 0.833, 0.824]  │
│ Accuracy()       │ 0.783       │ predict_mode │ [0.771, 0.78, 0.78, 0.78, 0.732, 0.817, 0.795, 0.78, 0.78, 0.793, 0.805, 0.768, 0.783, 0.841, 0.78, 0.744, 0.793, 0.768]       │
└──────────────────┴─────────────┴──────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
