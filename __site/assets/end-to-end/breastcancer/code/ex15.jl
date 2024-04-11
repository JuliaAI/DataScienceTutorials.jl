# This file was generated, do not modify it. # hide
models_to_evaluate = models(matching(X, y)) do m
    m.prediction_type==:probabilistic && m.is_pure_julia &&
        m.package_name != "SIRUS"
end

p = plot(legendfontsize=7, title="ROC Curve")
plot!([0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:black)
for m in models_to_evaluate
    model=m.name
    pkg = m.package_name
    model_name = "$model ($pkg)"
    @info "Evaluating $model_name. "
    eval(:(clf = @load $model pkg=$pkg verbosity=0))

    clf_machine = machine(clf(), X, y)
    fit!(clf_machine, rows=train, verbosity=0)

    y_pred = MLJ.predict(clf_machine, rows=test);

    fprs, tprs, thresholds = roc_curve(y_pred, y[test])
    plot!(p, fprs, tprs,label=model_name)
    gui()

    push!(model_names, model_name)
    push!(accuracies, accuracy(mode.(y_pred), y[test]))
    push!(log_losses, log_loss(y_pred,y[test]))
    push!(f1_scores, f1score(mode.(y_pred), y[test]))
end

#Adding labels and legend to the ROC-AUC curve
xlabel!("False Positive Rate (positive=malignant)")
ylabel!("True Positive Rate")

savefig(joinpath(@OUTPUT, "breastcancer_auc_curve.svg")); # hide