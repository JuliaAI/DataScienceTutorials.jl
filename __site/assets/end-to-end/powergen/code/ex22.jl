# This file was generated, do not modify it. # hide
plot(y_hat, color = "blue", label = "Predicted", xlim = (0, 100), xticks = [])
plot!(y_wind[test], color = "red", label = "Observed")
xlabel!("Time")
ylabel!("Power generation")

savefig(joinpath(@OUTPUT, "obs_v_pred.svg")); # hide