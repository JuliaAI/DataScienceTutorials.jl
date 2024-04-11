# This file was generated, do not modify it. # hide
rng = Xoshiro(123)
model = NeuralNetworkClassifier(
    ; builder,
    loss=(yhat, y)->Flux.tversky_loss(yhat, y, β=0.9), # combines precision and recall
    batch_size = round(Int, reduction*2048),
    epochs=50,
    rng,
)