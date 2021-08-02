# This file was generated, do not modify it. # hide
ensemble = machine(ensemble_model, X, y)
estimates = evaluate!(ensemble, resampling=CV())
estimates |> pprint