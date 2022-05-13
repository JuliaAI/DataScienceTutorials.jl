# This file was generated, do not modify it. # hide
y, X = unpack(df, ==(:Churn), !=(:customerID));
schema(X).names