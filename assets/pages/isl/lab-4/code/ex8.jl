# This file was generated, do not modify it. # hide
figure(figsize=(8,6))
cm = countmap(y)
bar([1, 2], [cm["Down"], cm["Up"]])
xticks([1, 2], ["Down", "Up"], fontsize=12)
yticks(fontsize=12)
ylabel("Number of occurences", fontsize=14)

savefig("assets/literate/ISL-lab-4-bal.svg") # hide