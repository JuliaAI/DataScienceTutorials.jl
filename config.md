<!--
Add here global page variables to use throughout your
website.
The website_* must be defined for the RSS to work
-->
@def prepath = "DataScienceTutorials.jl"

@def website_title = "Data Science Tutorials"
@def website_descr = "Data Science Tutorials using Julia"
@def website_url   = "https://alan-turing-institute.github.io/DataScienceTutorials.jl/"

@def author = "Thibaut Lienart, Anthony Blaom, Sebastian Vollmer and collaborators"

@def mintoclevel = 2 <!-- toc starts at h2 onwards -->
@def maxtoclevel = 3 <!-- toc stops at h3 included -->

@def showall = true

<!--
Add here global latex commands to use throughout your
pages. It can be math commands but does not need to be.
For instance:
* \newcommand{\phrase}{This is a long phrase to copy.}
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}

\newcommand{\tutorial}[1]{*Download the* ~~~<a href="https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/gh-pages/generated/notebooks/!#1.ipynb" target="_blank"><em>notebook</em></a>~~~, *the* ~~~<a href="https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/gh-pages/generated/scripts/!#1-raw.jl" target="_blank"><em>raw script</em></a>~~~, *or the* ~~~<a href="https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/gh-pages/generated/scripts/!#1.jl" target="_blank"><em>annotated script</em></a>~~~ *for this tutorial (right-click on the link and save).* <!--_-->\toc\literate{/_literate/!#1.jl}} <!--_-->

\newcommand{\refblank}[2]{~~~<a href="!#2" target="_blank">~~~!#1~~~</a>~~~}

\newcommand{\note}[1]{@@note @@title ⚠ Note@@ @@content #1 @@ @@}
