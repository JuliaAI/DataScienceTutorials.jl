+++
prepath = "DataScienceTutorials.jl"

website_title = "Data Science Tutorials"
website_descr = "Data Science Tutorials using Julia"
website_url   = "https://alan-turing-institute.github.io/DataScienceTutorials.jl/"

author = "Thibaut Lienart, Anthony Blaom, Sebastian Vollmer and collaborators"

mintoclevel = 2
maxtoclevel = 3
showall = true


# When developping it's sometimes useful to ignore specific folders or pages
# to speed things up; don't forget to "unignore" them afterwards.

ignore = [
#  "getting-started/stacking.md",
#  "end-to-end/crabs-xgb.md",
#  "end-to-end/boston-flux.md"
]

# ignore = ["data/", "getting-started/", "isl/", "end-to-end/"]
# current = "data/"
# current = "isl/"
# current = "end-to-end/"
# current = "getting-started/"
# ignore = [d for d in ignore if d != current]
+++

\newcommand{\nblink}[1]{
  ~~~
  <a href="https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/!#1/tutorial.ipynb" target="_blank"><em>notebook</em></a>
  ~~~
}
\newcommand{\sclink}[1]{
  ~~~
  <a href="https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/!#1/tutorial.jl" target="_blank"><em>annotated script</em></a>
  ~~~
}
\newcommand{\rawlink}[1]{
  ~~~
  <a href="https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/!#1/tutorial-raw.jl" target="_blank"><em>raw script</em></a>
  ~~~
}
\newcommand{\proj}[1]{https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/!#1/Project.toml}
\newcommand{\mani}[1]{https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/!#1/Manifest.toml}
\newcommand{\tgz}[1]{https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/!#1.tar.gz}


\newcommand{\tutorial}[1]{
  *Download the \nblink{!#1}, the \sclink{!#1} or the \rawlink{!#1} for this tutorial (right-click on the relevant link and save-as). These rely on [this Project.toml](\proj{!#1}) and [this Manifest.toml](\mani{!#1}).* \\
  *You can also download the whole [project folder](\tgz{#1}).*
  \toc\literate{/_literate/!#1/tutorial.jl}
}

\newcommand{\refblank}[2]{~~~<a href="!#2" target="_blank">~~~!#1~~~</a>~~~}

\newcommand{\note}[1]{@@note @@title ⚠ Note@@ @@content #1 @@ @@}
