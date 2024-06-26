@def title = "Data Science Tutorials in Julia"

## Learning by doing

This website offers tutorials for [MLJ.jl](https://JuliaAI.github.io/MLJ.jl/dev/) and related packages. 

The code included on each tutorial is tested to work reliably
under these two conditions:

- You are running Julia 1.7.x where "x" is any integer (to check, enter
  `VERSION` at the REPL).

- You have activated and instantiated the associated [package
  environment](https://docs.julialang.org/en/v1/stdlib/Pkg/).

To make the tutorial-specific environment available to you, first download (and
decompress) the "project folder" that is linked near the top of the
tutorial. How you proceed next depends on your chosen mode of interaction:


### Pasting code copied from web page directly into the Julia REPL

Recommended for new Julia users.

Activate and instantiate the correct environment by entering this code
at the `julia> ` prompt:

```julia
using Pkg; Pkg.activate("Path/To/Project/Folder"); Pkg.instantiate()
```

You need to replace `"Path/To/Project/Folder"` with the actual path to
the downloaded project folder.  This can be just `"."` if Julia has been
launched from the command-line, with the project folder as the current
directory.

This might take a few minutes for some tutorials, as packages may need
to be installed and precompiled.


### Running the provided Juptyer notebook

The downloaded project folder contains a Juptyer notebook called
`tutorial.ipynb`. See the [IJulia
documentation](https://julialang.github.io/IJulia.jl/stable/manual/running/)
on how to launch it. Copy and execute the code fragment above in a new
notebook cell before evaluating any other cells.

### Running the provided Julia script line-by-line from an IDE

In your IDE (e.g., VS Code or emacs) open the file called
`tutorial.jl` in the downloaded project folder and
activate/instantiate by first running the code fragment given above.

## Having problems?

Please report issues
[here](https://github.com/JuliaAI/DataScienceTutorials.jl/issues). For
beginners, the most common issues arise because the Julia version is
incorrect, or because of an incorrect package environment. So be sure
you have tried the instructions above before raising an issue.

If you need to use an earlier version of Julia, you can try deleting
the `Manifest.toml` file contained in the project folder and running
`using Pkg; Pkg.instantiate()` to generate a new package environment,
but the exact package versions will be different from those used to
test the tutorial and generate the output seen on the tutorial web
page.


## Elementary data manipulations

If you have some programming experience but are otherwise fairly new to data processing in Julia, you may appreciate the following few tutorials before moving on.
In these we provide an introduction to some of the fundamental packages in the Julia data processing universe such as [DataFrames], [CSV] and [CategoricalArrays].

[DataFrames]: https://github.com/JuliaData/DataFrames.jl
[CSV]: https://github.com/JuliaData/CSV.jl
[CategoricalArrays]: https://github.com/JuliaData/CategoricalArrays.jl

* How to [load data](/data/loading/),
* Short intro to [dataframes](/data/dataframe/),
* Dealing with [categorical data](/data/categorical/)
* Specifying [data interpretation](/data/scitype/)

## Getting started with MLJ

If you are new to MLJ but are familiar with Julia and with Machine Learning, we recommend you start by going through the short _Getting started_ examples in order:

1. How to [choose a model](/getting-started/choosing-a-model/),
1. How to [fit, predict and transform](/getting-started/fit-and-predict/)
1. How to [tune models](/getting-started/model-tuning/)
1. How to [ensemble models](/getting-started/ensembles/)
1. How to [ensemble models (2)](/getting-started/ensembles-2/)
1. More on [ensembles](/getting-started/ensembles-3/)
1. How to [compose models](/getting-started/composing-models/)
1. How to build a [learning network](/getting-started/learning-networks/)
1. How to [create models](/getting-started/learning-networks-2/) from learning networks
1. An extended tutorial on [stacking](/getting-started/stacking/)

Additionally, you can refer to the [documentation](https://JuliaAI.github.io/MLJ.jl/stable/) for more detailed information.

## Introduction to Statistical Learning with MLJ

This is a sequence of tutorials adapted from the labs associated with [_An introduction to statistical learning_](http://faculty.marshall.usc.edu/gareth-james/ISL/code.html) which were originally written in R.
These tutorials may be useful if you want a gentle intro to MLJ **and** other relevant tools in the Julia environment.
If you're fairly new to Julia and ML, this is probably where you should start.

**Note**: the adaptation is fairly liberal, adding content when it helps highlights specificities with MLJ and removing content when it seems unnecessary.
Also note that some of the things used in the ISL labs are not (yet) supported by MLJ.

* [Lab 2](/isl/lab-2/), a very short intro to Julia for data analysis
* [Lab 3](/isl/lab-3/), linear regression and metrics
* [Lab 4](/isl/lab-4/), classification with LDA, QDA, KNN and metrics
* [Lab 5](/isl/lab-5/), k-folds cross validation
* [Lab 6b](/isl/lab-6b/), Ridge and Lasso regression
* [Lab 8](/isl/lab-8/), Tree-based models
* [Lab 9](/isl/lab-9/), SVM (_partial_)
* [Lab 10](/isl/lab-10/), PCA and clustering (_partial_)

## End to end examples with MLJ

These are examples that are meant to show how MLJ can be used from loading data to producing a model.
They assume familiarity with Machine Learning and MLJ.

Note that these tutorials are not meant to teach you ML or Data Science; there may be better ways to analyse the data, the primary aim is to show quick analysis so that you can get more familiar with using MLJ.

The examples can be followed in any order, the tags can guide you as to which tutorials you may want to look at first.

* [Telco Churn (MLJ for Data Scientists in Two Hours)](/end-to-end/telco/), *intermediate*, *classification*, *one-hot*, *ROC curves*, *confusion matrices*, *feature importance*, *feature selection*, *controlling iteration*, *tree booster*, *hyper-parameter optimization (tuning)*.
* [AMES](/end-to-end/AMES/), *simple*, *regression*, *one-hot*, *learning network*, *tuning*, *deterministic*
* [Wine](/end-to-end/wine/), *simple*, *classification*, *standardizer*, *PCA*, *knn*, *multinomial*, *pipeline*
* [Crabs XGB](/end-to-end/crabs-xgb/), *simple*, *classification*, *xg-boost*, *tuning*
* [Horse](/end-to-end/horse/), *simple*, *classification*, *scientific type* and *autotype*, *missing values*, *imputation*, *one-hot*, *tuning*
* [King County Houses](/end-to-end/HouseKingCounty/), *simple*, *regression*, *scientific type*, *tuning*, *xg-boost*
* [Airfoil](/end-to-end/airfoil/), *simple*, *regression*, *random forest*
* [Boston LGBM](/end-to-end/boston-lgbm/), *intermediate*, *regression*, *LightGBM*
* [Boston Flux](/end-to-end/boston-flux/), *intermediate*, *regression*, *Flux*, *Neural Network*
* [Using GLM.jl](/end-to-end/glm/), *simple*, *regression*
* [Power Generation](/end-to-end/powergen/), *simple*, *feature pre-processing*, *regression*, *temporal data*
* [Breast cancer](/end-to-end/breastcancer/), *simple*, *model comparisons*, *binary classification*
