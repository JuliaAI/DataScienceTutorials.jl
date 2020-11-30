@def title = "Data Science Tutorials in Julia"

## Learning by doing

This website offers tutorials for [MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl) and related packages.
On each tutorial page, you will find a link to download the raw script and the notebook corresponding to the page.

Feedback and PRs are always welcome to help make these tutorials better, from the presentation to the content.

In order to reproduce the environment that was used to generate these tutorials, please follow these steps:
1. Go to the directory of your choice: `cd("/Users/[JohnDoe]/")`
2. Create a folder named, e.g., "MLJ\_tutorials": `mkdir("MLJ_tutorials")`
3. Download this \refblank{`Project.toml`}{https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml} and this \refblank{`Manifest.toml`}{https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml} in this folder;
4. In that folder, do
```julia-repl
julia> using Pkg; Pkg.activate("."); Pkg.instantiate();
```

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

Additionally, you can refer to the [documentation](https://alan-turing-institute.github.io/MLJ.jl/stable/) for more detailed information.

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

* [AMES](/end-to-end/AMES/), *simple*, *regression*, *one-hot*, *learning network*, *tuning*, *deterministic*
* [Wine](/end-to-end/wine/), *simple*, *classification*, *standardizer*, *PCA*, *knn*, *multinomial*, *pipeline*
* [Crabs XGB](/end-to-end/crabs-xgb/), *simple*, *classification*, *xg-boost*, *tuning*
* [Horse](/end-to-end/horse/), *simple*, *classification*, *scientific type* and *autotype*, *missing values*, *imputation*, *one-hot*, *tuning*
* [King County Houses](/end-to-end/HouseKingCounty/), *simple*, *regression*, *scientific type*, *tuning*, *xg-boost*.
* [Airfoil](/end-to-end/airfoil/), *simple*, *regression*, *random forest*
* [Boston LGBM](/end-to-end/boston-lgbm/), *intermediate*, *regression*, *LightGBM*
* [Using GLM.jl](/end-to-end/glm/), *simple*, *regression*.
* [Power Generation](/end-to-end/powergen/), *simple*, *feature pre-processing*, *regression*, *temporal data*.
