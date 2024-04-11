# This file was generated, do not modify it. # hide
histogram(data_nmiss.plant_age, color="blue",  bins=100, label="Plant Age Frequency",
          normalize=:pdf, alpha=0.5, xlim=(0,130))
vline!([mean_age], linewidth=2, color="red", label="Mean Age")
vline!([median_age], linewidth=2, color="orange", label="Median Age")


savefig(joinpath(@OUTPUT, "D0-processing-g2.svg")); # hide