# This file was generated, do not modify it. # hide
n = 10
machines = (machine(atom, Xs, ys) for i in 1:n)
ys = [predict(m, Xs) for  m in machines]
yhat = mean(ys);