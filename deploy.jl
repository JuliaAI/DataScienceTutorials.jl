# this runs in your environment and assumes that all your scripts are up to date etc.
# do not run this if you have not previously run `serve()` and checked everything was fine.

Pkg.activate()

using JuDoc, Pkg, Logging, NodeJS, Literate

##################################################################
## PART 1: generate all scripts and notebooks and push everything
# on the gh-pages branch (yes we're abusing the system)
##################################################################

Logging.disable_logging(Logging.LogLevel(1500))

ifiles = joinpath.("scripts", readdir("scripts"))

nbpath = joinpath("generated", "notebooks")
scpath = joinpath("generated", "scripts")

isdir(nbpath) || mkpath(nbpath)
isdir(scpath) || mkpath(scpath)

ACTIVATE = """
    # Before running this, make sure to instantiate the environment corresponding to
    # [this `Project.toml`](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Project.toml)
    # and [this `Manifest.toml`](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Manifest.toml)
    # so that you get an environment which matches the one used to generate the tutorials.
    #
    # To do so, copy both files in a folder, start Julia in that folder and
    #
    # ```julia
    # using Pkg
    # Pkg.activate(".")
    # Pkg.instantiate()
    # ```

    """

preproc(s) = ACTIVATE * s

Literate.notebook.(ifiles, nbpath, preprocess=preproc, execute=false, documenter=false)
Literate.script.(ifiles, scpath, postprocess=preproc, keep_comments=false, documenter=false)

JS_GHP = """
    var ghpages = require('gh-pages');
    ghpages.publish('generated/', function(err) {});
    """

run(`$(nodejs_cmd()) -e $JS_GHP`)

##################################################################
## PART 2
# optimize (compress and pre-render) the website and publish it
# to the master branch this time.
##################################################################

publish()
