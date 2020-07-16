# This file was generated, do not modify it. # hide
ms = models() do m
    Vector{Continuous} <: m.target_scitype
end
foreach(m -> println(m.name), ms)