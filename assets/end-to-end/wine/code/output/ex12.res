ProbabilisticPipeline(
    standardizer = Standardizer(
            features = Symbol[],
            ignore = false,
            ordered_factor = false,
            count = false),
    multinomial_classifier = MultinomialClassifier(
            lambda = 1.0,
            gamma = 0.0,
            penalty = :l2,
            fit_intercept = true,
            penalize_intercept = false,
            scale_penalty_with_samples = true,
            solver = nothing),
    cache = true)