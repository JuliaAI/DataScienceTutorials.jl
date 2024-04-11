# This file was generated, do not modify it. # hide
rpca = report(spca).pca
cs = cumsum(rpca.principalvars ./ rpca.tvar)