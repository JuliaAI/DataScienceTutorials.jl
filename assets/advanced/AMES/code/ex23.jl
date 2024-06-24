# This file was generated, do not modify it. # hide
tuned_blended = TunedModel(
    blended;
    tuning=Grid(resolution=7),
    resampling=CV(nfolds=6),
    ranges,
    measure=rmsl,
    acceleration=CPUThreads(),
)