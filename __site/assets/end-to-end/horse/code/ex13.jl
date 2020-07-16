# This file was generated, do not modify it. # hide
@load FillImputer
filler = machine(FillImputer(), datac)
fit!(filler)
datac = transform(filler, datac)

y, X = unpack(datac, ==(:outcome), name->true);
X = coerce(X, autotype(X, :discrete_to_continuous));