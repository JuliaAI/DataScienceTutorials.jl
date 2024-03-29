# This file was generated, do not modify it. # hide
figure(figsize=(8, 6))
for m in models(matching(X, y))
    if m.prediction_type==Symbol("probabilistic") && m.package_name=="ScikitLearn" && m.name!="LogisticCVClassifier"
        #Excluding LogisticCVClassfiier as we can infer similar baseline results from the LogisticClassifier

        #Capturing the model and loading it using the @load utility
        model_name=m.name
        package_name=m.package_name
        eval(:(clf = @load $model_name pkg=$package_name verbosity=1))

        #Fitting the captured model onto the training set
        clf_machine = machine(clf(), X, y)
        fit!(clf_machine, rows=train)

        #Getting the predictions onto the test set
        y_pred = MLJ.predict(clf_machine, rows=test);

        #Plotting the ROC-AUC curve for each model being iterated
        fprs, tprs, thresholds = roc(y_pred, y[test])
        plot(fprs, tprs,label=model_name);

        #Obtaining different evaluation metrics
        ce_loss = mean(cross_entropy(y_pred,y[test]))
        acc = accuracy(mode.(y_pred), y[test])
        f1_score = f1score(mode.(y_pred), y[test])

        #Adding the different obtained values of the evaluation metrics to the respective vectors
        push!(model_names, m.name)
        append!(loss_acc, acc)
        append!(loss_ce, ce_loss)
        append!(loss_f1, f1_score)
    end
end

#Adding labels and legend to the ROC-AUC curve
xlabel("False Positive Rate")
ylabel("True Positive Rate")
legend(loc="best", fontsize="xx-small")
title("ROC curve")
plt.savefig(joinpath(@OUTPUT, "breastcancer_auc_curve.svg")) # hide