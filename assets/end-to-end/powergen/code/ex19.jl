# This file was generated, do not modify it. # hide
linReg = LinearRegressor()
m_linReg = machine(linReg, X, y_wind)
fit!(m_linReg, rows=train);