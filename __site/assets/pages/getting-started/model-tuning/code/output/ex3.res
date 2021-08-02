MLJ.ProbabilisticTunedModel(model = DecisionTreeClassifier(pruning_purity = 1.0,
                                                           max_depth = -1,
                                                           min_samples_leaf = 1,
                                                           min_samples_split = 2,
                                                           min_purity_increase = 0.0,
                                                           n_subfeatures = 0,
                                                           display_depth = 5,
                                                           post_prune = false,
                                                           merge_purity_threshold = 0.9,
                                                           pdf_smoothing = 0.05,),
                            tuning = Grid(resolution = 10,
                                          acceleration = ComputationalResources.CPU1{Nothing}(nothing),),
                            resampling = Holdout(fraction_train = 0.7,
                                                 shuffle = false,
                                                 rng = Random._GLOBAL_RNG(),),
                            measure = MLJBase.CrossEntropy(),
                            weights = nothing,
                            operation = StatsBase.predict,
                            ranges = MLJ.NumericRange{Int64,Symbol}[NumericRange @ 3…41],
                            full_report = true,
                            train_best = true,) @ 1…61