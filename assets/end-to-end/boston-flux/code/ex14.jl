# This file was generated, do not modify it. # hide
bs = MLJ.range(nnregressor, :batch_size, lower=1, upper=5)

tm = MLJ.TunedModel(model=nnregressor, ranges=[bs, ], measure=MLJ.l2)