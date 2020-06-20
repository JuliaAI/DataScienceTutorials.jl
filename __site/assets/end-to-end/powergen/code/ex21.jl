# This file was generated, do not modify it. # hide
figure(figsize=(8, 6))
plot(y_hat, color="blue", label="Predicted")
plot(y_wind[test], color="red", label="Observed")
xlabel("Time", fontsize=14)
ylabel("Power generation", fontsize=14)
xticks([])
yticks(fontsize=12)
xlim(0, 100)
legend(fontsize=14)

savefig(joinpath(@OUTPUT, "obs_v_pred.svg")) # hide