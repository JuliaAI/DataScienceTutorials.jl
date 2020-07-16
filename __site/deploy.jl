# this runs in your environment and assumes that all your scripts are up to date etc.
# do not run this if you have not previously run `serve()` and checked everything was fine.

Pkg.activate()

using Franklin, Pkg, Logging, Literate

##################################################################
## PART 1: generate all scripts and notebooks and push everything
# on the gh-pages branch (yes we're abusing the system)
##################################################################

Logging.disable_logging(Logging.LogLevel(1500))

scripts = readdir("_literate")
filter!(e -> endswith(e, ".jl"), scripts)
ifiles = joinpath.("_literate", scripts)

nbpath = joinpath("__site", "generated", "notebooks")
scpath = joinpath("__site", "generated", "scripts")

isdir(nbpath) || mkpath(nbpath)
isdir(scpath) || mkpath(scpath)

ACTIVATE = """
    # Before running this, please make sure to activate and instantiate the environment
    # corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
    # so that you get an environment which matches the one used to generate the tutorials:
    #
    # ```julia
    # cd("DataScienceTutorials") # cd to folder with the *.toml
    # using Pkg; Pkg.activate("."); Pkg.instantiate()
    # ```

    """

preproc(s) = ACTIVATE * s

# Remove lines that end with `# hide`
postproc(s) = replace(s, r"(^|\n).*?#(\s)*?(?i)hide(?:all)?"=>s"\1")
postproc_nb(s) = replace(s, r",?\n.*?\".*?#\s*?(?i)hide(?:all)?.*?\""=>"")

# =============================================================================

get_fn(fp) = splitext(splitdir(fp)[2])[1]

for file in ifiles
   # Generate annotated notebooks
   Literate.notebook(file, nbpath, preprocess=preproc,
                     execute=false, documenter=false)
   nbp = joinpath(nbpath, splitext(splitdir(file)[2])[1] * ".ipynb")
   write(nbp, postproc_nb(read(nbp, String)))

   # Generate annotated scripts
   Literate.script(file, scpath,
                    postprocess=preproc ∘ postproc,
                    keep_comments=true, documenter=false)

   # Generate stripped scripts (no comments)
   Literate.script(file, scpath, name=get_fn(file)*"-raw",
                    postprocess=preproc ∘ postproc,
                    keep_comments=false, documenter=false)
end

##################################################################
## PART 2
# optimize (compress and pre-render) the website and publish it
# to the master branch this time.
##################################################################

commit = (@isdefined commit) ? commit : "fd-update"

publish(message=commit, final=lunr, minify=false, prerender=false)
