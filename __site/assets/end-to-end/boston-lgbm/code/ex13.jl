# This file was generated, do not modify it. # hide
predictions = MLJ.predict(mach, rows=test)
rms_score = round(rms(predictions, targets[test, 1]), sigdigits=4)

@show rms_score