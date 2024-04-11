# this runs in your environment and assumes that all your scripts are up to date etc.
# do not run this if you have not previously run `serve()` and checked everything was fine.

using Pkg
Pkg.activate(@__DIR__)
using Franklin, Pkg, Logging, Literate
import Base.(/)

(/)(ps...) = joinpath(ps...)

##################################################################
## PART 1: generate all scripts and notebooks and push everything
# on the gh-pages branch (yes we're abusing the system)
##################################################################

Logging.disable_logging(Logging.LogLevel(1500))

genpath = "__site"/"__generated"
isdir(genpath) || mkpath(genpath)


const LINK_INSTRUCTIONS =
    "https://juliaai.github.io/DataScienceTutorials.jl/#learning_by_doing"

LINK(dir, f) = "https://raw.githubusercontent.com/" *
               "juliaai/DataScienceTutorials.jl/gh-pages/__generated/" *
               "$(dir)/$(f)"

ACTIVATE(dir) = """
    # Before running this, please make sure to activate and instantiate the
    # tutorial-specific package environment, using this
    # [`Project.toml`]($(LINK(dir, "Project.toml"))) and
    # [this `Manifest.toml`]($(LINK(dir, "Manifest.toml"))), or by following
    # [these]($LINK_INSTRUCTIONS) detailed instructions.
    """

 function pre_process_script(io, s)
    chunks = Literate.parse(s)

    remove = Int[]
    rx  = r".*?#\s*?(?i)hideall.*?"
    rx2 = r".*?#\s*?(?i)hide.*?" # note: superset, doesn't matter

    for (i, c) in enumerate(chunks)
       c isa Literate.CodeChunk || continue
       remove_lines = Int[]
       hideall = false
       for (j, l) in enumerate(c.lines)
          if match(rx, l) !== nothing
             push!(remove, i)
             hideall = true
             break
          end
          if match(rx2, l) !== nothing
             push!(remove_lines, j)
          end
       end
       !hideall && deleteat!(c.lines, remove_lines)
    end
    deleteat!(chunks, remove)

    for c in chunks
       if c isa Literate.CodeChunk
          for l in c.lines
             println(io, l)
          end
       else
          for l in c.lines
             println(io, "# ", l.second)
          end
       end
       println(io, "")
    end
    return
 end




for dir in readdir("_literate")
   startswith(dir, "DRAFT") && continue

   script   = "_literate"/dir/"tutorial.jl"
   project  = "_literate"/dir/"Project.toml"
   manifest = "_literate"/dir/"Manifest.toml"

   path = genpath/dir
   isdir(path) || mkpath(path)

   cp(project,  path/"Project.toml",  force=true)
   cp(manifest, path/"Manifest.toml", force=true)

   preproc(s) = ACTIVATE(dir) * s

   temp_script = tempname()
   open(temp_script, "w") do ts
      s = preproc(read(script, String))
      pre_process_script(ts, s)
   end

   # Notebook
   Literate.notebook(temp_script, path, name="tutorial",
                     execute=false, documenter=false)

   # Annotated script
   Literate.script(temp_script, path, name="tutorial",
                   keep_comments=true, documenter=false)

   # Stripped script
   Literate.script(temp_script, path, name="tutorial-raw",
                    keep_comments=false, documenter=false)

   bk = pwd()
   cd(genpath)
   success(pipeline(`tar czf $dir.tar.gz $dir`))
   cd(bk)
end

##################################################################
## PART 2
# optimize (compress and pre-render) the website and publish it
# to the master branch this time.
##################################################################

commit = (@isdefined commit) ? commit : "fd-update"

publish(message=commit, final=lunr, minify=false, prerender=false)



# Filter code for hide / hideall
