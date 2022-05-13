# This file was generated, do not modify it. # hide
train, validation = partition(1:length(y), 0.7)
fit!(mach_pipe, rows=train)