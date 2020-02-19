# This file was generated, do not modify it. # hide
foo(x) = sum(abs.(x)) / length(x)
d = describe(boston, :mean, :median, :foo => foo)
first(d, 3)