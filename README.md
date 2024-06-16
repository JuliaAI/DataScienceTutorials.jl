# DataScienceTutorials.jl

This repository contains the source code for a [set of tutorials](https://juliaai.github.io/DataScienceTutorials.jl/) introducing the use of Julia and Julia packages such as MLJ, among others, to do "data science" in Julia.

## 📖 For readers

You can read the tutorials [online](https://juliaai.github.io/DataScienceTutorials.jl/).

You can find a runnable script for each tutorial linked at the top of each tutorial page along with a `Project.toml` and a `Manifest.toml` you can use to re-create the exact environment that was used to run the tutorial.

To do so, save both files in an appropriate folder, start Julia, `cd` to the folder and

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

**Note**: you are strongly encouraged to [open issues](https://github.com/juliaai/DataScienceTutorials.jl/issues/new) on this repository indicating points that are unclear or could be better explained, help us have great tutorials!

## 👩‍💻 For developers

The rest of these instructions assume that you've cloned the package and have `cd` to it.

### 📂 Structure
The following are the folders relevant to pages on the website:
```
├── _literate
│   ├── data             # has "Data Basics" tutorials
│   ├── getting-started  # has "Getting Started" tutorials
│   ├── isl              # has "Introduction to Statistical Learning" tutorials
│   ├── end-to-end       # has "End-to-End" tutorials
│   └── advanced         # has "Advanced" tutorials
├── data                 # This and the four folders below import content from "_literate" to the website 
├── getting-started
├── isl
├── end-to-end
├── advanced
├── info                 # has markdown files corresponding to info pages
├── index.md             # has markdown for the landing page
├── search.md            # has markdown for the search page
├── _libs/nav/head.js    # has all the navigation bar data
├── collapse-script.jl   # script that adds collapsible sections to tutorials
├── deploy.jl            # deployment script
└── Project.toml         # environment for dev operations, eg. deploy.jl
```
To understand the rest of the structure which could help you change styles with CSS or add interaction with JavaScript read the relevant page on [Franklin's documentation](https://franklinjl.org/workflow/).

### 👨🏻‍🔧 Modifying an existing tutorial

* Find the corresponding Julia script in `_literate` and fix it in a PR.
* Ensure it works and renders properly as explained below.


### ✨ Add a new tutorial

* Go to the appropriate folder inside `_literate` depending on the category of the tutorial as described above
* Duplicate one of the tutorials as a starting point.
* Remove `Manifest.toml` and `Project.toml`
* Create and activate an environment in that folder and add the packages that you'll need (MLJ, ...)
* Write your tutorial following the blueprint
* Run `julia collapse-script.jl` to add necessary Franklin syntax to your tutorial to make sections in it collapsible like other tutorials

> [!IMPORTANT]  
> Your tutorial **must** "just work" otherwise it will be ignored, in other words, any Julia user should be able to just copy the folder containing your `.jl` and `.toml` files, and run it without having to do anything special.

Once all that's done, the remaining things to do are to create the HTML page and a link in the appropriate location. Let's assume you wanted to add an E2E tutorial "Dinosaurs" then this implies that `_literate/end-to-end/dinosaurs.jl` exists and you would:

* Create a file `dinosaurs.md` in the top-level folder `end-to-end/` by duplicating the `end-to-end/wine.md` and changing the reference in it to `\tutorial{end-to-end/dinosaurs}`
* Add a link pointing to that tutorial in `_libs/nav/head.js` following the template so your tutorial shows in the navigation bar
* Ensure your tutorials renders correctly as explained in the next section.

> [!NOTE]  
> For plots, we do prefer that you use `Plots.jl` with the default backend. In general, try to avoid having Python as a dependency in your tutorial.

<details>
<summary> For more information about adding plots</summary>
<br>
Follow the pattern in existing tutorials; finish a code block defining a plot with:

```julia
savefig(joinpath(@OUTPUT, "MyTutorial-Fig1.svg")) # hide

# \figalt{the alt here}{MyTutorial-Fig1.svg}
```

Here "the alt here" is the text that appears if there is problem rendering the
figure. Please do not use anything else than SVG; please also stick to
this path and start the name of the file with the name of the tutorial
(to help keep files organised).

Do not forget to add the `# hide` which will ensure the line is not displayed on the website, notebook, or script.
</details>

### 👀 Visualise modifications locally

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Franklin
serve()
```

This makes Franklin to re-evaluate some of the code based on the changes which may take some time, progress is indicated in the REPL. Once it finishes it will open the browser to render the website after the changes.  

**Note**:
- If you decide to change some of the code while `serve()` is running, this is fine, Franklin will detect it and trigger an update of the relevant web pages (after evaluating the new code).

- This may generate some files under `__site` don't push them in your PR as they will be pushed upon deployment. 

- Avoid modifying the literate file, killing the Julia session, then calling `serve()` that sequence can cause weird issues where Julia will complain about the age of the world...


### 🚀 Publishing updates

**Assumptions**:

* you have a PR with changes, someone has reviewed them and they got merged into the master branch

* Be sure the version of Julia declared
  [here](https://github.com/JuliaAI/DataScienceTutorials.jl/blob/master/info/how-to-run-code.md)
  matches the version used to generate the web-site (which should match the version
  declared in each tutorial's Manifest.toml file)


**Once the changes are in the master branch:**

* Run `cd("path/to/DataScienceTutorials"); using Franklin` to launch Franklin
* In case you don't have `lunr` and `cheerio` installed already, also do:
```julia
using NodeJS
run(`sudo $(npm_cmd()) i lunr cheerio`)
```
* Run `serve(single=true, verb=true)` to ensure no issues generating the relevant html pages with code block evaluations
* Run `serve()` (after restarting) to serve the pages live on a local browser for viewing
* run `include("deploy.jl")` which re-generates the LUNR index and automatically pushes the changes to GitHub.


This should take ≤ 15 seconds to complete.

### 🕵🏽 Troubleshooting


#### Stale files

It can happen that something went wrong and you'd like to force Franklin to re-evaluate everything to clear things up. To do this, head to the parent markdown file (e.g. `my-tutorial.md`) and add below the other ones:

```julia
@def reeval = true
```

save the file, wait for Franklin to complete its update and then remove it (otherwise it will reevaluate the script every single pass which can slow things down a lot).

If you get an "age of the world" error, the `reeval` steps above usually works as well.

If you want to force the reevaluation of all tutorials at once, restart a Julia session and use

```julia
serve(; eval_all=true)
```

note that this will take a while.

#### Merge conflicts or Missing Styles

If you get merge conflicts or have new website styles that seem to be missing after `serve()`, do

```julia
cleanpull()
serve()
```

the first command will remove all stale generated HTML which may conflict with older ones.
