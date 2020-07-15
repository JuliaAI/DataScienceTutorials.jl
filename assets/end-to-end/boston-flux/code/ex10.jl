# This file was generated, do not modify it. # hide
preds = MLJ.predict(mach, features[test, :])

print(preds[1:5])