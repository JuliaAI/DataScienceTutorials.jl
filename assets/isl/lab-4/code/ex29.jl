# This file was generated, do not modify it. # hide
figure(figsize=(8,6))
cm = countmap(purchase)
bar([1, 2], [cm["No"], cm["Yes"]])
xticks([1, 2], ["No", "Yes"], fontsize=12)
yticks(fontsize=12)
ylabel("Number of occurences", fontsize=14)

savefig(joinpath(@OUTPUT, "ISL-lab-4-bal2.svg")) # hide