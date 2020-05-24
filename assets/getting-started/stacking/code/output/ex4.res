MyAverageTwo(
    regressor1 = LinearRegressor(
            fit_intercept = true,
            solver = nothing),
    regressor2 = KNNRegressor(
            K = 4,
            algorithm = :kdtree,
            metric = Euclidean(0.0),
            leafsize = 10,
            reorder = true,
            weights = :uniform)) @ 9…28