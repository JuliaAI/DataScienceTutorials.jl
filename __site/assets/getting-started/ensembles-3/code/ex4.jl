# This file was generated, do not modify it. # hide
surrogate = Deterministic()
mach = machine(surrogate, Xs, ys; predict=yhat)

fit!(yhat)
yhat(X[test, :])

@from_network mach begin
    mutable struct one_hundred_models
        atom=atom
    end
end

one_hundred_models_instance = one_hundred_models()