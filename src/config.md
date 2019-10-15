<!-----------------------------------------------------
Add here global page variables to use throughout your
website.
The website_* must be defined for the RSS to work
------------------------------------------------------->
@def prepath = "MLJTutorials"

@def website_title = "MLJ Tutorials"
@def website_descr = "Tutorials for the MLJ universe"
@def website_url   = "https://alan-turing-institute.github.io/MLJTutorials/"

@def author = "Thibaut Lienart &amp; Collaborators"

@def hasmath = false

\newcommand{\tutorial}[1]{*Download the* ~~~<a href="https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/gh-pages/notebooks/!#1.ipynb" target="_blank"><em>notebook</em></a>~~~ *or the* ~~~<a href="https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/gh-pages/scripts/!#1.jl" target="_blank"><em>raw script</em></a>~~~ *for this tutorial (right-click on the link and save).* <!--_-->\toc\literate{/scripts/!#1.jl}}
