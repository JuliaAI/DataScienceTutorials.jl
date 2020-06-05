# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# In this short tutorial we discuss two ways to easily load data in Julia:## 1. loading a standard dataset via `RDatasets.jl`,# 1. loading a local file with `CSV.jl`,## ## Using RDatasets## The package [RDatasets.jl](https://github.com/JuliaStats/RDatasets.jl) provides access to most of the many datasets listed on [this page](http://vincentarelbundock.github.io/Rdatasets/datasets.html).# These are well known, standard datasets that can be used to get started with data processing and classical machine learning such as for instance `iris`, `crabs`, `Boston`, etc.## To load such a dataset, you will need to specify which R package it belongs to as well as its name; for instance `Boston` is part of `MASS`.
using RDatasets

boston = dataset("MASS", "Boston");

# The fact that `Boston` is part of `MASS` is clearly indicated on the [list](http://vincentarelbundock.github.io/Rdatasets/datasets.html) linked to earlier.# While it can be a bit slow, loading a dataset via RDatasets is very simple and convenient as you don't have to  worry about setting the names of columns etc.## The `dataset` function returns a `DataFrame` object from the [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) package.
typeof(boston)

# For a short introduction to DataFrame objects, see [this tutorial](/data/dataframe).
# ## Using CSV## The package [CSV.jl](https://github.com/JuliaData/CSV.jl) offers a powerful way to read arbitrary CSV files efficiently.# In particular the `CSV.read` function allows to read a file and return a DataFrame.## ### Basic usage## Let's say you have a file `foo.csv` at some path `fpath=joinpath("data", "foo.csv")` with the content## ```# col1,col2,col3,col4,col5,col6,col7,col8# ,1,1.0,1,one,2019-01-01,2019-01-01T00:00:00,true# ,2,2.0,2,two,2019-01-02,2019-01-02T00:00:00,false# ,3,3.0,3.14,three,2019-01-03,2019-01-03T00:00:00,true# ```

c = """
col1,col2,col3,col4,col5,col6,col7,col8
,1,1.0,1,one,2019-01-01,2019-01-01T00:00:00,true
,2,2.0,2,two,2019-01-02,2019-01-02T00:00:00,false
,3,3.0,3.14,three,2019-01-03,2019-01-03T00:00:00,true
"""
fpath, = mktemp()
write(fpath, c);

# You can read it with CSV using
using CSV
data = CSV.read(fpath)

# Note that we use this `joinpath` for compatibility with  our system but you could pass any valid path on your system for instance `CSV.read("path/to/file.csv")`.# The data is also returned as a dataframe
typeof(data)

# Some of the useful arguments for `read` are:## * `header=` to specify whether there's a header, or which line the header is on or to specify a full header yourself,# * `skipto=` to specify how many rows to skip before starting to read the data,# * `limit=` to specify a maximum number of rows to parse,# * `missingstring=` to specify a string or vector of strings that should be parsed as missing values,# * `delim=','` a char or string to specify how columns are separated.## For more details see `?CSV.File`.## ### Example 1## Let's consider [this dataset](https://archive.ics.uci.edu/ml/machine-learning-databases/00504/), the content of which we saved in a file at path `fpath`.

c = """
3.26;0.829;1.676;0;1;1.453;3.770
2.189;0.58;0.863;0;0;1.348;3.115
2.125;0.638;0.831;0;0;1.348;3.531
3.027;0.331;1.472;1;0;1.807;3.510
2.094;0.827;0.86;0;0;1.886;5.390
3.222;0.331;2.177;0;0;0.706;1.819
3.179;0;1.063;0;0;2.942;3.947
3;0;0.938;1;0;2.851;3.513
2.62;0.499;0.99;0;0;2.942;4.402
2.834;0.134;0.95;0;0;1.591;3.021
2.405;0.134;0.843;0;0;1.769;3.210
2.728;0.223;0.953;0;0;1.591;2.371
2.512;0.223;0.929;1;0;1.769;3.919
2.834;0.134;1.237;0;0;1.859;3.030
2.819;0.331;1.271;0;1;0.981;2.736
2.126;0.251;1.114;0;0;0.143;2.157
2.834;0.134;1.322;0;0;1.199;2.413
3.014;0.56;1.781;0;0;-0.115;0.898
3.024;0.452;2.698;0;0;1.107;0.450
3.036;0.405;1.205;1;0;1.807;3.733
2.707;0.972;1.889;0;3;-1.169;2.976
2.978;1.246;1.103;0;1;3.988;6.535
3.111;0.732;0.923;0;0;4.068;5.643
"""
fpath, = mktemp()
write(fpath, c);

# It doesn't have a header so we have to provide it ourselves.
header = ["CIC0", "SM1_Dz", "GATS1i",
          "NdsCH", "NdssC", "MLOGP", "LC50"]
data = CSV.read(fpath, header=header)
first(data, 3)

# ### Example 2## Let's consider [this dataset](https://archive.ics.uci.edu/ml/machine-learning-databases/00423/), the content of which we saved at `fpath`.

c = """
1,0,1,0,0,0,0,1,0,1,1,?,1,0,0,0,0,1,0,0,0,0,1,67,137,15,0,1,1,1.53,95,13.7,106.6,4.9,99,3.4,2.1,34,41,183,150,7.1,0.7,1,3.5,0.5,?,?,?,1
0,?,0,0,0,0,1,1,?,?,1,0,0,1,0,0,0,1,0,0,0,0,1,62,0,?,0,1,1,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,1.8,?,?,?,?,1
1,0,1,1,0,1,0,1,0,1,0,0,0,1,1,0,0,0,0,1,0,1,1,78,50,50,2,1,2,0.96,5.8,8.9,79.8,8.4,472,3.3,0.4,58,68,202,109,7,2.1,5,13,0.1,28,6,16,1
1,1,1,0,0,0,0,1,0,1,1,0,0,1,0,0,0,0,0,0,0,1,1,77,40,30,0,1,1,0.95,2440,13.4,97.1,9,279,3.7,0.4,16,64,94,174,8.1,1.11,2,15.7,0.2,?,?,?,0
1,1,1,1,0,1,0,1,0,1,0,0,0,1,1,0,0,0,0,0,0,0,1,76,100,30,0,1,1,0.94,49,14.3,95.1,6.4,199,4.1,0.7,147,306,173,109,6.9,1.8,1,9,?,59,15,22,1
1,0,1,0,?,0,0,1,0,?,0,1,0,0,0,0,0,1,1,1,0,0,1,75,?,?,1,1,2,1.58,110,13.4,91.5,5.4,85,3.4,3.5,91,122,242,396,5.6,0.9,1,10,1.4,53,22,111,0
1,0,0,0,?,1,1,1,0,0,1,0,?,0,0,0,0,0,0,0,0,0,1,49,0,0,0,1,1,1.4,138.9,10.4,102,3.2,42000,2.35,2.72,119,183,143,211,7.3,0.8,5,2.6,2.19,171,126,1452,0
1,1,1,0,?,0,0,1,0,1,1,?,0,0,0,0,0,0,1,1,1,0,1,61,?,20,3,1,1,1.46,9860,10.8,92,3,58,3.1,3.2,79,108,184,300,7.1,0.52,2,9,1.3,42,25,706,0
1,1,1,0,0,0,0,1,0,1,1,0,0,1,0,0,0,?,1,1,0,0,1,50,100,32,1,1,2,3.14,8.8,11.9,107.5,4.9,70,1.9,3.3,26,59,115,63,6.1,0.59,1,6.4,1.2,85,73,982,1
1,1,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,43,100,0,0,1,1,1.12,1.8,11.8,87.8,5100,193000,4.2,0.5,71,45,256,303,7.1,0.59,1,9.3,0.7,?,?,?,1
1,0,1,0,0,0,1,1,?,?,0,0,0,0,0,0,0,?,1,1,0,0,1,41,?,?,0,1,2,1.05,100809,13,94.2,5.7,196,4.4,3,90,334,494,236,7.6,0.8,5,?,1.1,?,?,?,0
1,0,1,0,0,0,1,1,1,0,0,0,0,1,0,0,0,?,0,1,0,0,1,74,?,0,0,1,1,1.33,86,15.7,96.7,4,61,3.7,1.3,132,168,113,154,?,7.6,5,1.9,0.3,144,41,277,1
1,0,1,0,0,0,0,1,0,1,1,0,0,1,0,0,?,?,1,1,1,0,0,66,?,30,0,1,1,1.53,60,13.3,90.1,5.5,207000,4.4,8.5,25,36,35,74,8.5,0.73,1,5,0.8,?,?,?,1
1,?,0,0,0,0,1,1,?,?,0,0,0,0,0,0,0,0,0,0,0,0,1,56,0,?,0,1,1,1.2,6.6,13.7,93.8,4.1,91000,4.5,1,103,96,205,70,8.8,0.88,1,22,?,82,24,?,1
1,0,1,0,0,0,0,1,0,?,1,0,0,1,0,0,?,1,1,1,0,0,1,63,?,?,2,2,2,1.25,29,13.5,93,6,128,3.15,10.5,76,116,165,163,7.3,1.07,4,4.5,4.5,197,84,302,1
0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,1,41,100,0,1,1,2,1.61,4.6,10.2,89.6,5.5,161,3.1,3.1,24,57,163,176,5,0.8,2,2.6,1.3,25,13,60,1
1,0,1,0,0,0,0,1,?,1,1,?,1,0,0,0,?,?,1,1,1,0,1,72,?,?,3,2,1,2.14,60,12.1,99.2,5,58,2.4,9.8,69,63,201,235,6.2,0.96,2,2,2.9,136,95,767,0
1,1,1,0,0,0,0,1,0,1,0,0,?,0,0,0,?,1,1,1,1,1,1,60,100,60,2,1,1,1.05,9.2,10.3,103.7,5.4,159,3.8,0.5,56,91,459,146,5.4,1.23,5,13.5,3.8,187,58,443,1
1,?,1,0,0,0,0,1,?,1,0,?,0,1,1,0,0,1,0,0,0,0,1,64,200,78,1,1,1,1.13,8.8,14.9,94.8,6.3,137,4.3,0.9,16,23,82,180,6.5,4.95,1,5.4,0.9,144,49,295,1
1,1,1,0,0,0,0,1,?,?,0,0,0,1,0,0,0,1,1,1,1,0,1,75,500,?,0,1,3,1.44,34,15.9,103.4,9600,101000,3.4,3.4,27,87,260,147,6.3,0.9,5,2.3,1.6,67,34,774,0
"""
fpath, = mktemp()
write(fpath, c);

# It does not have a header and missing values indicated by `?`.
data = CSV.read(fpath, header=false, missingstring="?")
first(data[:, 1:5], 3)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

