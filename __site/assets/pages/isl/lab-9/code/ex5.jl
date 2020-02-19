# This file was generated, do not modify it. # hide
@load SVC pkg=LIBSVM

svc_mdl = SVC()
svc = machine(svc_mdl, X, y)

fit!(svc);