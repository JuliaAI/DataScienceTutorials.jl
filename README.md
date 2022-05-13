# DataScienceTutorials.jl

This repository contains the source code for a [set of tutorials](https://juliaai.github.io/DataScienceTutorials.jl/) introducing the use of Julia and Julia packages such as MLJ (but not only) to do "data science" in Julia.

## For readers

You can read the tutorials [online](https://juliaai.github.io/DataScienceTutorials.jl/).

You can find a runnable script for each tutorial at the top of each tutorial page along with a `Project.toml` and a `Manifest.toml` you can use to re-create the exact environment that was used to run the tutorial.

To do so, save both files in an appropriate folder, start Julia, `cd` to the folder and

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

**Note**: you are strongly encouraged to [open issues](https://github.com/juliaai/DataScienceTutorials.jl/issues/new) on this repository indicating points that are unclear or could be better explained, help us have great tutorials!

## For developers

The rest of these instructions assume that you've cloned the package and have `cd` to it.

### Structure

All tutorials correspond to a Literate script that's in `_literate/`.

### Fixing an existing tutorial

Find the corresponding script, fix it in a PR.

### Add a new tutorial

* Duplicate the folder `EX-wine`.
* Change its name:
  * `EX-somename` for an "end-to-end" tutorial `somename`
  * `A-somename` for a "getting started" tutorial `somename`
  * `D0-somename` for a "data" tutorial `somename`
  * `ISL-lab-x` for an "Introduction to Statistical Learning" tutorial
* Remove `Manifest.toml` and `Project.toml`
* Activate that folder and add the packages that you'll need (MLJ, ...)
* Write your tutorial following the blueprint

**Note**: your tutorial **must** "just work" otherwise it will be ignored, in other words, we should be able to just copy the folder containing your `.jl` and `.toml` files, and run it without having to do anything special.

Once all that's done, the remaining things to do are to create the HTML page and a link in the appropriate location. Let's assume you wanted to add an E2E tutorial "Dinosaurs" then in the previous step you'd have `EX-dinosaurs` and you would

* create a file `dinosaurs.md` in `end-to-end/` by duplicating the `end-to-end/wine.md` and changing the reference in it to `\tutorial{EX-dinosaurs}`
* add links pointing to that tutorial
  * in `index.md` following the template
  * in `_layout/head.html` following the template


### Publishing updates

**Assumptions**:

* you have a PR with changes, someone has reviewed them and they got merged into the main branch

**Once the changes are in the main branch**:

* run `cd("path/to/DataScienceTutorials"); using Franklin` to launch Franklin
* run `serve(single=true, verb=true)` to ensure no issues generating the relevant html pages with code block evaluations, and then run `serve()` (after restarting?) to serve the pages live on a local browser for viewing
* run `include("deploy.jl")` to re-generate the LUNR index and push the changes to GitHub.

The second step requires you have `lunr` and `cheerio` installed, if not:

```
using NodeJS
run(`sudo $(npm_cmd()) i lunr cheerio`)
```

This should take ≤ 15 seconds to complete.

---

# Old instructions (still valid)

### Visualise modifications locally

```julia
cd("path/to/DataScienceTutorials")
using Franklin
serve()
```

If you have changed the *code* of some of the literate scripts, Franklin will need to re-evaluate some of the code which may take some time, progress is indicated in the REPL.

If you decide to change some of the code while `serve()` is running, this is fine, Franklin will detect it and trigger an update of the relevant web pages (after evaluating the new code).

**Notes**:
- avoid modifying the literate file, killing the Julia session, then calling `serve()` that sequence can cause weird issues where Julia will complain about the age of the world...
- the `serve()` command above activates the environment.

### Plots

For the moment, plots are done with `PyPlot.jl` (though you're not restricted to use it).
It's best not to use `Plots.jl` because the loading time would risk making full updates of the webpage annoyingly slow.

In order to display a plot, finish a code block defining a plot with

```
savefig(joinpath(@OUTPUT, "MyTutorial-Fig1.svg")) # hide

# \figalt{the alt here}{MyTutorial-Fig1.svg}
```

Here "the alt here" is the text that appears if there is problem rendering the
figure. Please do not use anything else than SVG; please also stick to
this path and start the name of the file with the name of the tutorial
(to help keep files organised).

Do not forget to add the `# hide` which will ensure the line is not displayed on the website, notebook, or script.

### Troubleshooting

#### Stale files

It can happen that something went wrong and you'd like to force Franklin to re-evaluate everything to clear things up. To do this, head to the parent markdown file (e.g. `my-tutorial.md`) and add below the other ones:

```julia
@def reeval = true
```

save the file, wait for Franklin to complete its update and then remove it (otherwise it will reevaluate the script every single pass which can slow things down a lot).

If you get an "age of the world" error, the `reeval` steps above usually works as well.

If you want to force the reevaluation of everything once, restart a Julia session and use

```julia
serve(; eval_all=true)
```

note that this will take a while.

#### Merge conflicts

If you get merge conflicts, do

```julia
cleanpull()
serve()
```

the first command will remove all stale generated HTML which may conflict with older ones.
