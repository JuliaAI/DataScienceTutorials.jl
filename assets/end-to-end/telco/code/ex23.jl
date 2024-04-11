# This file was generated, do not modify it. # hide
import Random.Xoshiro
rng = Xoshiro(123)
df, df_test, df_dumped = partition(df0, 0.07, 0.03; # in ratios 7:3:90
                                   stratify=df0.Churn,
                                   rng=rng);