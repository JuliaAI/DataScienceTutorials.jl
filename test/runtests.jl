# This file was originally developed to test that each tutorial.jl file could be
# executed. When written, all tutorials were based on a *single* Manifest.toml, appearing
# at the top level. But now each tutorial get's it's own environment and the approach
# taken here does not work.

@warn """

Testing of tutorials with `test DataScienceTutorials` no longer performs any testing. See
comments at top of /test/runtests.jl.

"""

using Pkg, Test, Logging, Random

if false

const curdir = @__DIR__
const scripts_dir = normpath(joinpath(curdir, "..", "_literate"))

function finish(bko, bke, wro, rdo, wre, rde)
    redirect_stdout(bko)
    redirect_stderr(bke)
    close(wro)
    close(rdo)
    close(wre)
    close(rde)
end

function try_run(tf)
    bko = stdout
    bke = stderr
    (rdo, wro) = redirect_stdout()
    (rde, wre) = redirect_stderr()
    @sync begin
        Logging.disable_logging(Logging.LogLevel(3_000))
        try
            include(tf)
        catch e
            Logging.disable_logging(Logging.Debug)
            finish(bko, bke, wro, rdo, wre, rde)
            @show e
        end
        Logging.disable_logging(Logging.Debug)
    end
    finish(bko, bke, wro, rdo, wre, rde)
end

"""
    strip_code

Gets the julia code out, unless if the block starts with `# notest` in which
case it's ignored (useful for plots and ScikitLearn things which will fail on
travis).
"""
function strip_code(fpath)
    lines = readlines(fpath)
    jc = IOBuffer()
    record = true
    is_ci = get(ENV, "CI", "false") == "true"
    for line in lines
        if is_ci && startswith(line, "# notest")
            record = false
            continue
        end
        if record
            # is it code?
            startswith(line, "# ") && continue
            # is it a savefig ?
            startswith(line, "savefig") && continue
            # it is
            write(jc, line * "\n")
        else
            # toggle it back on if new block
            if startswith(line, "# ")
                record = true
            end
        end
    end
    tp = tempname()
    write(tp, take!(jc))
    return tp
end

const rng = Random.Xoshiro(round(Int, time()))
const complete = true

for (root, _, files) in walkdir(scripts_dir), file in files

    contains(root, "CondaPkg") && continue
    last(split(file, ".")) == "jl" || continue

    root_stub = last(splitdir(root))


    # NOTE: If you want to run a single file in isolation, uncomment next line and
    # comment out the block that follows it:

    # startswith(root_stub, "ISL-lab-4") || continue

    file == ".DS_Store" && continue

    @testset "testing $root_stub/$file" begin
        println("\n\n>> looking at $root_stub/$file ...")
        path = joinpath(root, file)
        tf = tempname()
        write(tf, """
                module Tester
                    using Franklin
                    import ..strip_code
                    include(strip_code("$path"))
                end
                """)
        @test begin
            try_run(tf); true
        end
    end
end
println("All done 🍻")

end
