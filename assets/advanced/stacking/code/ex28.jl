# This file was generated, do not modify it. # hide
mutable struct MyTwoModelStack <: DeterministicNetworkComposite
    model1
    model2
    judge
end

function prefit(::MyTwoModelStack, verbosity, X, y)

    Xs = source(X)
    ys = source(y)

    f = node(Xs) do x
        folds(x, 3)
    end

    m11 = machine(:model1, corestrict(Xs, f, 1), corestrict(ys, f, 1))
    m12 = machine(:model1, corestrict(Xs, f, 2), corestrict(ys, f, 2))
    m13 = machine(:model1, corestrict(Xs, f, 3), corestrict(ys, f, 3))

    y11 = predict(m11, restrict(Xs, f, 1));
    y12 = predict(m12, restrict(Xs, f, 2));
    y13 = predict(m13, restrict(Xs, f, 3));

    y1_oos = vcat(y11, y12, y13);

    m21 = machine(:model2, corestrict(Xs, f, 1), corestrict(ys, f, 1))
    m22 = machine(:model2, corestrict(Xs, f, 2), corestrict(ys, f, 2))
    m23 = machine(:model2, corestrict(Xs, f, 3), corestrict(ys, f, 3))
    y21 = predict(m21, restrict(Xs, f, 1));
    y22 = predict(m22, restrict(Xs, f, 2));
    y23 = predict(m23, restrict(Xs, f, 3));

    y2_oos = vcat(y21, y22, y23);

    X_oos = MLJ.table(hcat(y1_oos, y2_oos))
    m_judge = machine(:judge, X_oos, ys)

    m1 = machine(:model1, Xs, ys)
    m2 = machine(:model2, Xs, ys)

    y1 = predict(m1, Xs);
    y2 = predict(m2, Xs);
    X_judge = MLJ.table(hcat(y1, y2))
    yhat = predict(m_judge, X_judge)

    return (predict=yhat,)
end