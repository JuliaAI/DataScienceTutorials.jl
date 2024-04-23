21×4 DataFrame
 Row │ ModelName                          Accuracy  LogLoss    F1Score
     │ String                             Any       Any        Any
─────┼──────────────────────────────────────────────────────────────────
   1 │ NeuralNetworkClassifier (MLJFlux)  0.973684  0.0852176  0.965517
   2 │ NeuralNetworkClassifier (BetaML)   0.982456  0.0889816  0.97619
   3 │ RandomForestClassifier (Decision…  0.95614   0.114434   0.942529
   4 │ RandomForestClassifier (BetaML)    0.938596  0.121808   0.915663
   5 │ EvoTreeClassifier (EvoTrees)       0.95614   0.127662   0.941176
   6 │ BayesianLDA (MultivariateStats)    0.929825  0.166699   0.9
   7 │ BayesianSubspaceLDA (Multivariat…  0.929825  0.166709   0.9
   8 │ SubspaceLDA (MultivariateStats)    0.938596  0.209371   0.91358
   9 │ AdaBoostStumpClassifier (Decisio…  0.947368  0.275107   0.926829
  10 │ KernelPerceptronClassifier (Beta…  0.912281  0.400981   0.886364
  11 │ KNNClassifier (NearestNeighborMo…  0.95614   0.430947   0.942529
  12 │ PegasosClassifier (BetaML)         0.903509  0.444873   0.876404
  13 │ ConstantClassifier (MLJModels)     0.622807  0.662744   0.0
  14 │ LDA (MultivariateStats)            0.938596  0.677149   0.91358
  15 │ GaussianNBClassifier (NaiveBayes)  0.929825  0.898701   0.906977
  16 │ PerceptronClassifier (BetaML)      0.947368  1.31957    0.926829
  17 │ MultinomialClassifier (MLJLinear…  0.938596  1.57496    0.915663
  18 │ DecisionTreeClassifier (BetaML)    0.95614   1.58694    0.941176
  19 │ LogisticClassifier (MLJLinearMod…  0.938596  2.20713    0.915663
  20 │ LinearBinaryClassifier (GLM)       0.912281  2.88829    0.878049
  21 │ DecisionTreeClassifier (Decision…  0.912281  3.16172    0.886364