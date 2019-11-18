@def title = "MLJ Tutorials"
@def hascode = true

## Learning by doing

This website offers tutorials for [MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl) and related `MLJ*` packages.
On each tutorial page, you will find a link to download the raw script and the notebook corresponding to the page.

Feedback and PRs are always welcome to help make these tutorials better!

In order to reproduce the environment that was used to generate these tutorials, please download this \refblank{`Project.toml`}{https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml} and this \refblank{`Manifest.toml`}{https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml} in a folder and, in that folder, do

```julia-repl
julia> using Pkg; Pkg.activate("."); Pkg.instantiate();
```

## Getting started

If you are new to MLJ but are familiar with Machine Learning, we recommend you start by going through the short _Getting started_ examples in order:

1. How to [choose a model](/pub/getting-started/choosing-a-model.html),
1. How to [fit, predict and transform](/pub/getting-started/fit-and-predict.html)
1. How to [tune models](/pub/getting-started/model-tuning.html)
1. How to [ensemble models](/pub/getting-started/ensembles.html)
1. How to [ensemble models (2)](/pub/getting-started/ensembles-2.html)
1. How to [compose models](/pub/getting-started/composing-models.html)
1. How to build a [learning network](/pub/getting-started/learning-networks.html)
1. How to [create models](/pub/getting-started/learning-networks-2.html) from learning networks

Additionally, you can refer to the [documentation](https://alan-turing-institute.github.io/MLJ.jl/stable/) for more detailed information.

## End to end examples

These are examples that are meant to show how MLJ can be used from loading data to producing a model.
They assume familiarity with Machine Learning and MLJ.

Note that these tutorials are not meant to teach you ML or Data Science; there may be better ways to analyse the data, the primary aim is to show quick analysis so that you can get more familiar with using MLJ.

The examples can be followed in any order, the tags can guide you as to which tutorials you may want to look at first.

* [AMES](/pub/end-to-end/AMES.html), *simple*, *regression*, *one-hot*, *learning network*, *tuning*, *deterministic*
* [Wine](/pub/end-to-end/wine.html), *simple*, *classification*, *standardizer*, *PCA*, *knn*, *multinomial*, *pipeline*
* [Crabs XGB](/pub/end-to-end/crabs-xgb.html), *simple*, *classification*, *xg-boost*, *tuning*
* [Horse](/pub/end-to-end/horse.html), *simple*, *classification*, *scientific type* and *autotype*, *missing values*, *imputation*, *one-hot*, *tuning*


## Introduction to Statistical Learning

This is a sequence of tutorials adapted from the labs associated with [_An introduction to statistical learning_](http://faculty.marshall.usc.edu/gareth-james/ISL/code.html) which were originally written in R.
These tutorials may be useful if you want a gentle intro to MLJ **and** other relevant tools in the Julia environment.
If you're fairly new to Julia and ML, this is probably where you should start.

**Note**: the adaptation is fairly liberal, adding content when it helps highlights specificities with MLJ and removing content when it seems unnecessary.
Also note that some of the things used in the ISL labs are not (yet) supported by MLJ.

* [Lab 2](/pub/isl/lab-2.html), a very short intro to Julia for data analysis
* [Lab 3](/pub/isl/lab-3.html), linear regression and metrics
* [Lab 4](/pub/isl/lab-4.html), classification with LDA, QDA, KNN and metrics
* [Lab 5](/pub/isl/lab-5.html), k-folds cross validation
* [Lab 6b](/pub/isl/lab-6b.html), Ridge and Lasso regression
* [Lab 8](/pub/isl/lab-8.html), Tree-based models
* [Lab 9](/pub/isl/lab-9.html), SVM (_partial_)
* [Lab 10](/pub/isl/lab-10.html), PCA and clustering (_ongoing_)
