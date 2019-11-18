using Test, Logging

const curdir = @__DIR__
const scripts_dir = normpath(joinpath(curdir, "..", "scripts"))

for (root, _, files) in walkdir(scripts_dir), file in files
    # we don't want to test scripts that plot stuff, as that will break on
    # travis.
    splitdir(file)[2] in (
        "A-ensembles.jl",     # has plots
        "A-ensembles-2.jl",   # has plots
        "EX-crabs-xgb.jl",    # has plots
        "EX-wine.jl",         # has plots
        "ISL-lab-4.jl",       # has plots
        "ISL-lab-8.jl",       # has SckitLearn
        ) && get(ENV, "CI", "false") == "true" && continue

    # NOTE: for some reason if something uses one of ScikitLearn's
    # model Travis errors (fails to load ScikitLearn_.Model)
    # NOTE 2: everything *will* be tested if run locally, as it should.

    # uncomment this to individually test specific files

#    splitdir(file)[2] != "ISL-lab-8.jl" && continue

    @testset "testing $file" begin
        println("\n\n>> looking at $file ...")
        path = joinpath(root, file)
        tf = tempname()
        write(tf, """
        module Tester
            import ScikitLearn
            include("$path")
        end
        """)
        @test begin
            bk = stdout
            (rd, wr) = redirect_stdout()
            Logging.disable_logging(Logging.LogLevel(3_000))
            include(tf)
            Logging.disable_logging(Logging.Debug)
            redirect_stdout(bk)
            close(wr)
            close(rd)
            true
        end
    end
end
