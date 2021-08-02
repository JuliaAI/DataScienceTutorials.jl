# This file was generated, do not modify it. # hide
tm = TunedModel(model=ensemble_model,
                tuning=Grid(resolution=10), # 10x10 grid
                resampling=Holdout(fraction_train=0.8, rng=42),
                ranges=[B_range, K_range])

tuned_ensemble = machine(tm, X, y)
fit!(tuned_ensemble, rows=train);