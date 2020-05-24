# This file was generated, do not modify it. # hide
rpca = first(values(report(spca).report_given_machine))
cs = cumsum(rpca.principalvars ./ rpca.tvar)