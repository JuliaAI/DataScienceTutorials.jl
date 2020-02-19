# This file was generated, do not modify it. # hide
sch = schema(datac)
for (name, scitype) in zip(sch.names, sch.scitypes)
    println(rpad("$name", 30), scitype)
end