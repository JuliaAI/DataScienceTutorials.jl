+++
prepath = "DataScienceTutorials.jl"

website_title = "Data Science Tutorials"
website_descr = "Data Science Tutorials using Julia"
website_url   = "https://alan-turing-institute.github.io/DataScienceTutorials.jl/"

author = "Thibaut Lienart, Anthony Blaom, Sebastian Vollmer and collaborators"

mintoclevel = 2
maxtoclevel = 3
showall = true

ignore = ["end-to-end/", "getting-started/", "isl/"]
+++

<!--
Add here global latex commands to use throughout your
pages. It can be math commands but does not need to be.
For instance:
* \newcommand{\phrase}{This is a long phrase to copy.}
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}

<!-- \newcommand{\tutorial}[1]{*Download the* ~~~<a href="https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/gh-pages/generated/notebooks/!#1.ipynb" target="_blank"><em>notebook</em></a>~~~, *the* ~~~<a href="https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/gh-pages/generated/scripts/!#1-raw.jl" target="_blank"><em>raw script</em></a>~~~, *or the* ~~~<a href="https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/gh-pages/generated/scripts/!#1.jl" target="_blank"><em>annotated script</em></a>~~~ *for this tutorial (right-click on the link and save).* \toc\literate{/_literate/!#1.jl}}  -->

\newcommand{\tutorial}[1]{
  \toc\literate{/_literate/!#1/tutorial.jl}
}

\newcommand{\refblank}[2]{~~~<a href="!#2" target="_blank">~~~!#1~~~</a>~~~}

\newcommand{\note}[1]{@@note @@title ⚠ Note@@ @@content #1 @@ @@}
