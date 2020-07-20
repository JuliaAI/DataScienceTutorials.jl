# This file was generated, do not modify it. # hide
y1 = log.(y0)
y = transform(fit!(machine(UnivariateStandardizer(), y1),
                   verbosity=0), y1);