# This file was generated, do not modify it. # hide
sch = schema(X)
println(rpad(" Name", 28), "| Scitype")
println("-"^45)
for (name, scitype) in zip(sch.names, sch.scitypes)
    println(rpad("$name", 30), scitype)
end