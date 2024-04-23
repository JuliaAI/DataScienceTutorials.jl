# This file was generated, do not modify it. # hide
MLJ.restrict(X::AbstractNode, f::AbstractNode, i) =  node(X, f) do XX, ff
    restrict(XX, ff, i)
end
MLJ.corestrict(X::AbstractNode, f::AbstractNode, i) = node(X, f) do XX, ff
    corestrict(XX, ff, i)
end