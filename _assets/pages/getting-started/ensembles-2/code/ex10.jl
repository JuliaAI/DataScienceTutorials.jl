# This file was generated, do not modify it. # hide
tuned_forest = TunedModel(model=forest,
                          tuning=Grid(resolution=3),
                          resampling=CV(nfolds=6, rng=32),
                          ranges=[r_sf, r_bf],
                          measure=rms)
m = machine(tuned_forest, X, y)
e = evaluate!(m, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e |> pprint