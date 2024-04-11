# This file was generated, do not modify it. # hide
# name of the features including one-hot-encoded ones

all_names = [:AtBat, :Hits, :HmRun, :Runs, :RBI, :Walks, :Years,
        :CAtBat, :CHits, :CHmRun, :CRuns, :CRBI, :CWalks,
        :League__A, :League__N, :Div_E, :Div_W,
        :PutOuts, :Assists, :Errors, :NewLeague_A, :NewLeague_N]

idxshow = collect(1:length(coef_vals))[abs.(coef_vals).>0]

plot(
    coef_vals,
    xticks = (idxshow, all_names),
    legend = false,
    xrotation = 90,
    line = :stem,
    marker = :circle,
    size = ((800, 700)),
)
hline!([0], linewidth = 2, color = :red)
ylabel!("Amplitude")
xlabel!("Coefficient")

savefig(joinpath(@OUTPUT, "ISL-lab-6-g6.svg")); # hide