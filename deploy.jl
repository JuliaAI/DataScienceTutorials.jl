# this runs in your environment and assumes that all your scripts are up to date etc.
# do not run this if you have not previously run `serve()` and checked everything was fine.
using Franklin, Pkg, Logging, Literate
import Base.(/)
Pkg.activate()

(/)(ps...) = joinpath(ps...)

##################################################################
## PART 1: generate all scripts and notebooks and push everything
# on the gh-pages branch (yes we're abusing the system)
##################################################################

Logging.disable_logging(Logging.LogLevel(1500))

genpath = "__site"/"__generated"
isdir(genpath) || mkpath(genpath)

LINK(dir, f) = "https://raw.githubusercontent.com/" *
               "juliaai/DataScienceTutorials.jl/gh-pages/__generated/" *
               "$(dir)/$(f)"

ACTIVATE(dir) = """
    # Before running this, please make sure to activate and instantiate the
    # environment with [this `Project.toml`]($(LINK(dir, "Project.toml"))) and
    # [this `Manifest.toml`]($(LINK(dir, "Manifest.toml"))).
    # For instance, copy these files to a folder '$dir', `cd` to it and
    #
    # ```julia
    # using Pkg; Pkg.activate("."); Pkg.instantiate()
    # ```

    """

for dir in readdir("_literate")
   startswith(dir, "DRAFT") && continue

   script   = "_literate"/dir/"tutorial.jl"
   project  = "_literate"/dir/"Project.toml"
   manifest = "_literate"/dir/"Manifest.toml"

   path = genpath/dir
   isdir(path) || mkpath(path)

   cp(project,  path/"Project.toml",  force=true)
   cp(manifest, path/"Manifest.toml", force=true)

   preproc(s)     = ACTIVATE(dir) * s
   postproc(s)    = replace(s, r"(^|\n).*?#(\s)*?(?i)hide(?:all)?"=>s"\1")
   postproc_nb(s) = replace(s, r",?\n.*?\".*?#\s*?(?i)hide(?:all)?.*?\""=>"")

   # Notebook
   Literate.notebook(script, path, preprocess=preproc,
                     execute=false, documenter=false)
   nbp = path/"tutorial.ipynb"
   write(nbp, postproc_nb(read(nbp, String)))

   # Annotated script
   Literate.script(script, path, postprocess=preproc ∘ postproc,
                   keep_comments=true, documenter=false)

   # Stripped script
   Literate.script(script, path, name="tutorial-raw",
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
