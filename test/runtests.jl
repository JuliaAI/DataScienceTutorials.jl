using Test, Logging

const curdir = @__DIR__
const scripts_dir = normpath(joinpath(curdir, "..", "scripts"))

for (root, _, files) in walkdir(scripts_dir), file in files
    # we don't want to test scripts that plot stuff, as that will break on
    # travis.
    splitdir(file)[2] in ("A-ensembles.jl",
                          "A-ensembles-2.jl",
                          "EX-crabs-xgb.jl",
                          "EX-wine.jl",
                          "ISL-lab-4.jl") && continue

    @testset "testing $file" begin
        println("\n\n>> looking at $file ...")
        path = joinpath(root, file)
        tf = tempname()
        write(tf, """
        module Tester
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
