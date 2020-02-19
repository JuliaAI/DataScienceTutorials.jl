# This file was generated, do not modify it. # hide
X = select(carseats, Not([:Sales, :High]))
y = carseats.High;