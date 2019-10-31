using Test

foo(path) = (include(path); true)

curdir = @__DIR__
scripts_dir = normpath(joinpath(curdir, "..", "scripts"))

for (root, _, files) in walkdir(scripts_dir), file in files
    @testset "testing $file" begin
        @test foo(joinpath(root, file))
    end
end
