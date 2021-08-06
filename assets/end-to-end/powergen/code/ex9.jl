# This file was generated, do not modify it. # hide
n_rows = size(first(dfs), 1)
for (df, name) in zip(dfs, col_mean)
    df[!, name] = zeros(n_rows)
    for (i, row) in enumerate(eachrow(df))
      df[i, name] = mean(row)
    end
end;