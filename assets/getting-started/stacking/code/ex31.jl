# This file was generated, do not modify it. # hide
@from_network machine(Deterministic(), X, y; predict=yhat) begin
    mutable struct MyTwoModelStack
        regressor1=model1
        regressor2=model2
        judge=judge
    end
end

my_two_model_stack = MyTwoModelStack()