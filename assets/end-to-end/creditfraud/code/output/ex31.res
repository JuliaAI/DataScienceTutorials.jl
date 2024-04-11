NeuralNetworkClassifier(
  builder = GenericBuilder(
        apply = Main.FD_SANDBOX_9924936464897923302.var"#1#2"()), 
  finaliser = NNlib.softmax, 
  optimiser = Flux.Optimise.Adam(0.001, (0.9, 0.999), 1.0e-8, IdDict{Any, Any}()), 
  loss = Main.FD_SANDBOX_9924936464897923302.var"#3#4"(), 
  epochs = 50, 
  batch_size = 102, 
  lambda = 0.0, 
  alpha = 0.0, 
  rng = Random.Xoshiro(0xfefa8d41b8f5dca5, 0xf80cc98e147960c1, 0x20e2ccc17662fc1d, 0xea7a7dcb2e787c01, 0xf4e85a418b9c4f80), 
  optimiser_changes_trigger_retraining = false, 
  acceleration = ComputationalResources.CPU1{Nothing}(nothing))