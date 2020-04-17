# This fairness analysis of COMPAS dataset has been adapted partly from the [COMPAS analysis by Aequitas](https://dssg.github.io/aequitas/examples/compas_demo.html)

# ## Introduction to fairness and bias analysis
#
# Recent work in the Machine Learning community has raised concerns about the risk of unintended bias in Algorithmic Decision-Making systems, affecting individuals unfairly. While many bias metrics and fairness definitions have been proposed in recent years, the community has not reached a consensus on which definitions and metrics should be used, and there has been very little empirical analyses of real-world problems using the proposed metrics.

# ## COMPAS Dataset
#
# Northpointe’s COMPAS (Correctional Offender Management Profiling for Alternative Sanctions) is one of the most widesly utilized risk assessment tools/ algorithms within the criminal justice system for guiding decisions such as how to set bail. The ProPublica dataset represents two years of COMPAS predicitons from Broward County, FL.

# ## Getting started

using DataFrames, MLJ, CSV, VegaLite
using HTTP

MLJ.color_off() # hide

req = HTTP.get("https://raw.githubusercontent.com/dssg/aequitas/master/examples/data/compas_for_aequitas.csv")

df = CSV.read(req.body)
df[1:5, :] |> pretty

#

schema(df)

#

df = coerce(df, Textual=>OrderedFactor)
df = coerce(df, :score=>Count)
schema(df)

# ## Levels of recidivism

df |>
@vlplot(
    :bar,
    width=50,
    height=50,
    column="race:o",
    y={"count()", axis={title="count", grid=false}},
    x={"label_value:n", axis={title=""}},
    color={"label_value:n", scale={range=["#675193", "#ca8861"]}},
    spacing=10,
    config={
        view={stroke=:transparent},
        axis={domainWidth=1}
    }
) |> save(joinpath(@OUTPUT,"COMPAS_plot1.svg"))

# \figalt{Levels of recidivism}{COMPAS_plot1.svg}

# ## Model Training
#
# Now we will train a AdaBoostClassifier to predict the label_value. In this tutorial we will be training only on entity_id, age, sex and race. The actual COMPAS Dataset contains multiple columns. But for simplicity, we will be training only on these 4 values.


# ## Data Preprocessing
#
# We unpack our dataframe, convert our target labels to categorical. Then we use the Transformer:OneHotEncoder provided by MLJ.

y, X = unpack(df, ==(:label_value), col -> true);

y = categorical(y);

X = X[[:entity_id, :race, :sex, :age_cat]]
X = coerce(X, Count=>Continuous);

X = transform(fit!(machine(OneHotEncoder(), X)), X);

train, test = partition(eachindex(y), 0.7, shuffle=true);

schema(X)

#

aboost = @load AdaBoostClassifier pkg=ScikitLearn
aboost_m = machine(aboost, X, y);
fit!(aboost_m, rows=train);
pred_aboost = MLJ.predict(aboost_m, rows=test);

# Each value in pred_aboost is UnivariateFinite with predicted probability of each label. To simplify the discussion, we now convert pred_aboost to a simple array where the label with higher probability is chosen.

y_pred = Array{Int64, 1}(undef, 2164);

for i in range(1, stop=length(pred_aboost))
    y_pred[i] = pred_aboost[i].prob_given_class[1]>0.5 ? 0 : 1
end

# Now we create a DataFrame of test rows and create a new column for the predictions the model made.

df_test = df[test, :]

insertcols!(df_test, 2, :pred=>y_pred);

schema(df_test)

# ## Plot of the count of predicted labels for each value of race

df_test |>
@vlplot(
    :bar,
    width=50,
    height=50,
    column="race:o",
    y={"count()", axis={title="count", grid=false}},
    x={"pred:n", axis={title=""}},
    color={"pred:n", scale={range=["#675193", "#ca8861"]}},
    spacing=10,
    config={
        view={stroke=:transparent},
        axis={domainWidth=1}
    }
) |> save(joinpath(@OUTPUT,"COMPAS_plot2.svg"))

# \figalt{count of predicted labels}{COMPAS_plot2.svg}

# ## Fairness Metrics
#
# Now we find the values of False Negative Rate, False Positive Rate, True Negative Rate and True Positive Rate. Values of other metrics like Equal Opportunity Score, etc can be calculated

for r in ["African-American", "Caucasian", "Hispanic"]
    indices = [x==r for x in df_test[:race]]
    ŷ = df_test[indices, :pred]
    ŷ = convert(CategoricalArray, ŷ)
    y_test = convert(CategoricalArray, y[test])
    println("Printing values for the race : ", r)
    println("False Negative Rate : ", false_negative_rate(ŷ, y_test[indices]))
    println("False Positive Rate : ", false_positive_rate(ŷ, y_test[indices]))
    println("True Negative Rate : ", true_negative_rate(ŷ, y_test[indices]))
    println("True Positive Rate : ", true_positive_rate(ŷ, y_test[indices]))
    println()
end

# Above analysis was performed on the sensitive attribute : race. Similar analysis could also be performed on the other protected attributes : Sex and Age
