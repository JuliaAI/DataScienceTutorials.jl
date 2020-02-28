# This file was generated, do not modify it. # hide
for col in names(df)
    nmissings = sum(ismissing, df[!,col])
    if nmissings > 0
        println(rpad("$col has ", 25), nmissings, " missings")
    end
end