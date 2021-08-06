# This file was generated, do not modify it. # hide
for m in models(matching(X, y))
    println("Model name = ",m.name,", ","Prediction type = ",m.prediction_type,", ","Package name = ",m.package_name);
end