# MLJTutorials

[![Tutorials status](https://travis-ci.com/alan-turing-institute/MLJTutorials.svg?branch=master)](https://travis-ci.com/alan-turing-institute/MLJTutorials)

This repository contains tutorials for MLJ.
Currently the main aim is to add many tutorials presenting different perspectives and contexts through which the MLJ-way should become more apparent.
The organisation is rudimentary at the moment and once there are more tutorials, we will try to improve that.
If you have suggestions or recommendations or would like to help, please o pen an issue here, thanks!

The rest of this readme assumes that your current directory is `MLJTutorials`.

## For readers

You can read the tutorials [online](https://alan-turing-institute.github.io/MLJTutorials/).

If you want to experiment on the side and make sure you have an identical environment to the one used to generate those tutorials, please **activate** and **instantiate** the environment using [this Project.toml](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Project.toml) file and [this Manifest.toml](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Manifest.toml) file.

To do so, save both files in an appropriate folder, start Julia, `cd` to the folder and

```julia
using Pkg
Pkg.activate(".")
Pkg.insantiate()
```

Each tutorial has a link at the top for a notebook or the raw script which you can download by right-clicking on the link and selecting "*Save file as...*".

**Note**: you are strongly encouraged to [open issues](https://github.com/alan-turing-institute/MLJTutorials/issues/new) on this repository indicating points that are unclear or could be better explained, help us have great tutorials!

---

## For developers

### Important first steps

Start by running this line in your REPL (_always_):

```julia-repl
julia> include("start.jl")
```

When it's time to push updates, **only** use `include("deploy.jl")` (assuming you have admin rights) as this also re-generates notebooks and scripts and pushes everything at the right place (see [this point](#push-updates)).

**Note**: keep your tutorials short! if there's a tuning step at some point, do it on a high resolution search locally and only show a rough search in the right area in the tutorial otherwise running tutorials can take a long time.

### Modifying literate scripts

1. add packages if you need additional ones (`] add ...`), make sure to update explicit compat requirements in the `Project.toml` file
1. add/modify tutorials in the `scripts/` folder
1. to help display things neatly on the webpage (no horizontal overflow), prefer `pprint` from `PrettyPrinting.jl` to display things like `NamedTuple`
1. add `;` at the end of final lines of code blocks if you want to suppress output

### Adding a page

Say you've added a new script `A-my-tutorial.jl`, follow these steps to add a corresponding page on the website:

1. copy one of the markdown file available in `src/pages/getting-started` and paste it somewhere appropriate e.g.: `src/pages/getting-started/my-tutorial.md`
2. modify the title on that page, `# My tutorial`
3. modify the `\tutorial` command to `\tutorial{A-my-tutorial}` (no extensions)

By now you have at `src/pages/getting-started/my-tutorial.md`

```markdown
@def hascode = true
@def showall = true

# My tutorial

\tutorial{A-my-tutorial}
```

The last thing to do is to add a link to the page in `src/_html_parts/head.html` so that it can be navigated to, copy paste the appropriate list item modifying the names so for instance:

```html
<li class="pure-menu-item {{ispage pub/getting-started/my-tutorial.html}}pure-menu-selected{{end}}"><a href="/pub/getting-started/my-tutorial.html" class="pure-menu-link">⊳ My tutorial</a></li>
```

### Visualise modifications locally

```julia
cd("path/to/MLJTutorials")
using JuDoc
serve()
```

If you have changed the *code* of some of the literate scripts, JuDoc will need to re-evaluate some of the code which may take some time, progress is indicated in the REPL.

If you decide to change some of the code while `serve()` is running, this is fine, JuDoc will detect it and trigger an update of the relevant web pages (after evaluating the new code).

**Notes**:
- avoid modifying the literate file, killing the Julia session, then calling `serve()` that sequence can cause weird issues where Julia will complain about the age of the world...
- the `serve()` command above activates the environment.

### Plots

For the moment, plots are done with `PyPlot.jl` (though you're not restricted to use it).
It's best not to use `Plots.jl` because the loading time would risk making full updates of the webpage annoyingly slow.

In order to display a plot, finish a code block defining a plot with

```
savefig("assets/literate/MyTutorial-Fig1.svg") # hide

# ![](/assets/literate/MyTutorial-Fig1.svg)
```

Please do not use anything else than SVG; please also stick to this path and start the name of the file with the name of the tutorial (to help keep files organised).

Do not forget to add the `# hide` which will ensure the line is not displayed on the website, notebook, or script.

### Troubleshooting

#### Stale files

It can happen that something went wrong and you'd like to force JuDoc to re-evaluate everything to clear things up. To do this, head to the parent markdown file (e.g. `my-tutorial.md`) and add below the other ones:

```julia
@def reeval = true
```

save the file, wait for JuDoc to complete its update and then remove it (otherwise it will reevaluate the script every single pass which can slow things down a lot).

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

### Push updates

*Requirements*:

* admin access to the repo
* `] add Literate JuDoc NodeJS`
* install `highlight.js` and `gh-pages` from within Julia: ``run(`sudo $(npm_cmd()) i highlight.js gh-pages`)``

Assuming you have all that, just run

```julia
include("deploy.jl")
```

This should take ≤ 15 seconds to complete.

If you don't have some of the requirements, or if something failed, just open a PR.

### Continuous Integration

To help maintain tutorials, most of them are tested on Travis.
However tutorials that include plotting should **not** be included.
Please adjust the file `test/runtests.jl` accordingly following the example.
