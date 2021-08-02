JuDoc.MyPipe(hot = OneHotEncoder(features = Symbol[],
                                 drop_last = false,
                                 ordered_factor = true,),
             knn = MLJModels.NearestNeighbors_.KNNRegressor(K = 3,
                                                            algorithm = :kdtree,
                                                            metric = Distances.Euclidean(0.0),
                                                            leafsize = 10,
                                                            reorder = true,
                                                            weights = :uniform,),
             target = UnivariateStandardizer(),) @ 2…71