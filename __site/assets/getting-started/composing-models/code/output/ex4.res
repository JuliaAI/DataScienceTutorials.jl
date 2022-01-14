DeterministicPipeline(
    coercer = Main.FD_SANDBOX_11083188621274373481.var"#1#2"(),
    one_hot_encoder = OneHotEncoder(
            features = Symbol[],
            drop_last = false,
            ordered_factor = true,
            ignore = false),
    transformed_target_model = TransformedTargetModelDeterministic(
            model = KNNRegressor,
            target = UnivariateStandardizer,
            inverse = nothing,
            cache = true),
    cache = true)