using Test

foo(path) = (include(path); true)

curdir = @__DIR__
scripts_dir = normpath(joinpath(curdir, "..", "scripts"))

for (root, _, files) in walkdir(scripts_dir), file in files
    # we don't want to test scripts that plot stuff, as that will break on
    # travis.
    splitdir(file)[2] in ("A-ensembles.jl",
                          "A-ensembles-2.jl",
                          "EX-crabs-xgb.jl",
                          "EX-wine.jl") && continue

    @testset "testing $file" begin
        @test foo(joinpath(root, file))
    end
end
