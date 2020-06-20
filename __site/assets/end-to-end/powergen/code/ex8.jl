# This file was generated, do not modify it. # hide
nrows = size(first(dfs), 1)
for (df, name) in zip(dfs, col_mean)
    df[!, name] = zeros(nrows)
    for (i, row) in enumerate(eachrow(df))
      df[i, name] = mean(row)
    end
end;