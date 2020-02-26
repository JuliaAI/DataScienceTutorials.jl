# This file was generated, do not modify it. # hide
function print_performance(model, data...)
    e = evaluate(model, data...;
                 resampling=CV(rng=1234, nfolds=8),
                 measure=rms,
                 verbosity=0)
    μ = round(e.measurement[1], sigdigits=5)
    ste = round(std(e.per_fold[1])/sqrt(8), digits=5)
    println("$model = $μ ± $(2*ste)")
end;

X, y = @load_boston

print_performance(linear, X, y)
print_performance(knn, X, y)
print_performance(avg, X, y)