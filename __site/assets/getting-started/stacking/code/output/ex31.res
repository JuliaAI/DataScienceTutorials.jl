MyTwoModelStack(
    regressor1 = LinearRegressor(
            fit_intercept = true,
            solver = nothing),
    regressor2 = KNNRegressor(
            K = 5,
            algorithm = :kdtree,
            metric = Distances.Euclidean(0.0),
            leafsize = 10,
            reorder = true,
            weights = NearestNeighborModels.Uniform()),
    judge = LinearRegressor(
            fit_intercept = true,
            solver = nothing)) @155