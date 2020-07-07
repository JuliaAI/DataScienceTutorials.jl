(machines = Any[NodalMachine{LinearRegressor} @ 3…40, NodalMachine{OneHotEncoder} @ 1…96, NodalMachine{Standardizer} @ 3…59],
 fitted_params_given_machine = OrderedCollections.LittleDict{Any,Any,Array{Any,1},Array{Any,1}}(NodalMachine{LinearRegressor} @ 3…40 => (coef = [1.0207869497405524, 1.0324289154699695, 0.009406292423317654, 0.026633915171207466, 0.2998591563637023], intercept = 0.015893883995789795),NodalMachine{OneHotEncoder} @ 1…96 => (fitresult = OneHotEncoderResult @ 1…66,),NodalMachine{Standardizer} @ 3…59 => (mean_and_std_given_feature = Dict(:V1 => (0.002445630070647992, 1.1309193246154066),:V2 => (-0.015561621122145304, 1.123889789756524),:V5 => (0.007703620970455889, 1.1421493464876624),:V3 => (0.024428898843138463, 2.3327135683191544),:V4 => (0.15168404285157286, 6.806065861835238)),)),)