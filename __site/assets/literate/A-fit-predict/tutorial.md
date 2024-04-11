<!--This file was generated, do not modify it.-->
````julia:ex1
using Pkg # hideall
Pkg.activate("_literate/A-fit-predict/Project.toml")
Pkg.instantiate()
````

[MLJ.jl]: https://github.com/alan-turing-institute/MLJ.jl
[RDatasets.jl]: https://github.com/JuliaStats/RDatasets.jl
[DecisionTree.jl]: https://github.com/bensadeghi/DecisionTree.jl

@@dropdown
## Preliminary steps
@@
@@dropdown-content

@@dropdown
### Data
@@
@@dropdown-content

As in "[choosing a model](/getting-started/choosing-a-model/)", let's load the Iris dataset and unpack it:

````julia:ex2
using MLJ
import Statistics
using PrettyPrinting
using StableRNGs

MLJ.color_off() # hide
X, y = @load_iris;
````

let's also load the `DecisionTreeClassifier`:

````julia:ex3
DecisionTreeClassifier = @load DecisionTreeClassifier pkg=DecisionTree
tree_model = DecisionTreeClassifier()
````

‎
@@
@@dropdown
### MLJ Machine
@@
@@dropdown-content

In MLJ, remember that a *model* is an object that only serves as a container for the hyperparameters of the model.
A *machine* is an object wrapping both a model and data and can contain information on the *trained* model; it does *not* fit the model by itself.
However, it does check that the model is compatible with the scientific type of the data and will warn you otherwise.

````julia:ex4
tree = machine(tree_model, X, y)
````

A machine is used both for supervised and unsupervised model.
In this tutorial we give an example for the supervised model first and then go on with the unsupervised case.

‎
@@

‎
@@
@@dropdown
## Training and testing a supervised model
@@
@@dropdown-content

Now that you've declared the model you'd like to consider and the data, we are left with the standard training and testing step for a supervised learning algorithm.

@@dropdown
### Splitting the data
@@
@@dropdown-content

To split the data into a *training* and *testing* set, you can use the function `partition` to obtain indices for data points that should be considered either as training or testing data:

````julia:ex5
rng = StableRNG(566)
train, test = partition(eachindex(y), 0.7, shuffle=true, rng=rng)
test[1:3]
````

‎
@@
@@dropdown
### Fitting and testing the machine
@@
@@dropdown-content

To fit the machine, you can use the function `fit!` specifying the rows to be used for the training:

````julia:ex6
fit!(tree, rows=train)
````

Note that this **modifies** the machine which now contains the trained parameters of the decision tree.
You can inspect the result of the fitting with the `fitted_params` method:

````julia:ex7
fitted_params(tree) |> pprint
````

This `fitresult` will vary from model to model though classifiers will usually give out a tuple with the first element corresponding to the fitting and the second one keeping track of how classes are named (so that predictions can be appropriately named).

You can now use the machine to make predictions with the `predict` function specifying rows to be used for the prediction:

````julia:ex8
ŷ = predict(tree, rows=test)
@show ŷ[1]
````

Note that the output is *probabilistic*, effectively a vector with a score for each class.
You could get the mode by using the `mode` function on `ŷ` or using `predict_mode`:

````julia:ex9
ȳ = predict_mode(tree, rows=test)
@show ȳ[1]
@show mode(ŷ[1])
````

To measure the discrepancy between `ŷ` and `y` you could use the cross entropy:

````julia:ex10
mce = cross_entropy(ŷ, y[test])
round(mce, digits=4)
````

‎
@@

‎
@@
@@dropdown
## Unsupervised models
@@
@@dropdown-content

Unsupervised models define a `transform` method,
and may optionally implement an `inverse_transform` method.
As in the supervised case, we use a machine to wrap the unsupervised model and the data:

````julia:ex11
v = [1, 2, 3, 4]
stand_model = UnivariateStandardizer()
stand = machine(stand_model, v)
````

We can then fit the machine and use it to apply the corresponding *data transformation*:

````julia:ex12
fit!(stand)
w = transform(stand, v)
@show round.(w, digits=2)
@show mean(w)
@show std(w)
````

In this case, the model also has an inverse transform:

````julia:ex13
vv = inverse_transform(stand, w)
sum(abs.(vv .- v))
````

‎
@@

