using Test, Logging

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

for (root, _, files) in walkdir(scripts_dir), file in files

    # NOTE: if want to run a single file  in isolation, uncomment line below

#    splitdir(file)[2] ∉ ("ISL-lab-8.jl",) && continue
#    startswith(splitdir(file)[2], "ISL-lab-4") || continue

    file == ".DS_Store" && continue

    @testset "testing $file" begin
        println("\n\n>> looking at $file ...")
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
