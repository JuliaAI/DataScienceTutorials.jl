<!--This file was generated, do not modify it.-->
# This tutoral uses the World Resources Institute Global Power Plants Dataset to explore data pre-processing in Julia.
The dataset is created from multiple sources and is under continuous update, which means that there are lots of missing data, non-standard characters, etc
Hence plenty of material to work with!

More tutorials on the manipulation of DataFrames can be found [here](https://github.com/bkamins/Julia-DataFrames-Tutorial)
And some more information can be found on [this](https://en.wikibooks.org/wiki/Introducing_Julia/DataFrames) wikipage.

```julia:ex1
import MLJ: schema, std, mean, median, coerce, coerce!, scitype
```

