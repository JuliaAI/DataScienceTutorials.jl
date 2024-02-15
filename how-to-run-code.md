# Running Code in the Website

The code included on each tutorial is tested to work reliably
under these two conditions:

- You are running Julia 1.7.x where "x" is any integer (to check, enter
  `VERSION` at the REPL).

- You have activated and instantiated the associated [package
  environment](https://docs.julialang.org/en/v1/stdlib/Pkg/).

To make the tutorial-specific environment available to you, first download (and
decompress) the "project folder" that is linked near the top of the
tutorial. How you proceed next depends on your chosen mode of interaction:


### Pasting code copied from web page directly into the Julia REPL

Recommended for new Julia users.

Activate and instantiate the correct environment by entering this code
at the `julia> ` prompt:

```julia
using Pkg; Pkg.activate("Path/To/Project/Folder"); Pkg.instantiate()
```

You need to replace `"Path/To/Project/Folder"` with the actual path to
the downloaded project folder.  This can be just `"."` if Julia has been
launched from the command-line, with the project folder as the current
directory.

This might take a few minutes for some tutorials, as packages may need
to be installed and precompiled.


### Running the provided Juptyer notebook

The downloaded project folder contains a Juptyer notebook called
`tutorial.ipynb`. See the [IJulia
documentation](https://julialang.github.io/IJulia.jl/stable/manual/running/)
on how to launch it. Copy and execute the code fragment above in a new
notebook cell before evaluating any other cells.

### Running the provided Julia script line-by-line from an IDE

In your IDE (e.g., VS Code or emacs) open the file called
`tutorial.jl` in the downloaded project folder and
activate/instantiate by first running the code fragment given above.

## Having problems?

Please report issues
[here](https://github.com/JuliaAI/DataScienceTutorials.jl/issues). For
beginners, the most common issues arise because the Julia version is
incorrect, or because of an incorrect package environment. So be sure
you have tried the instructions above before raising an issue.

If you need to use an earlier version of Julia, you can try deleting
the `Manifest.toml` file contained in the project folder and running
`using Pkg; Pkg.instantiate()` to generate a new package environment,
but the exact package versions will be different from those used to
test the tutorial and generate the output seen on the tutorial web
page.

