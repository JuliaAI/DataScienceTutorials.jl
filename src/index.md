@def title = "MLJ Tutorials"
@def hascode = true

## Learning by doing

This website offers tutorials for [MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl) and related `MLJ*` packages.
On each tutorial page, you will find a link to download the raw script and/or the notebook corresponding to the page.

In order to reproduce the environment that was used to generate these tutorials, please download this \refblank{`Project.toml`}{https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml} and this \refblank{`Manifest.toml`}{https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml} in a folder and, in that folder, do

```julia-repl
julia> using Pkg; Pkg.activate("."); Pkg.instantiate();
```

## Getting started

If you are new to MLJ but are familiar with Machine Learning, we recommend you start by going through the short _Getting started_ examples in order:

1. How to [choose a model](/pub/getting-started/choosing-a-model.html),
1. How to [fit, predict and transform](/pub/getting-started/fit-and-predict.html)
1. How to [tune models](/pub/getting-started/model-tuning.html)
1. How to [compose models](/pub/getting-started/composing-models.html)
1. How to build a [learning network](/pub/getting-started/learning-networks.html)

Additionally, you can refer to the [documentation](https://alan-turing-institute.github.io/MLJ.jl/stable/) for more detailed information.

## End to end examples

These are examples that are meant to show how MLJ can be used from loading data to producing a model.
They assume familiarity with Machine Learning and MLJ.
The examples can be followed in any order, the tags can guide which tutorials you may want to look at first.

* [AMES](/pub/end-to-end/AMES.html), *simple*, *regression*, *one-hot*, *learning network*, *tuning*, *deterministic*
* [Crabs XGB](/pub/end-to-end/crabs-xgb.html), *simple*, *classification*, *xg-boost*, *tuning*
