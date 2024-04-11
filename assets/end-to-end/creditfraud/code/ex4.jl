# This file was generated, do not modify it. # hide
table = urldownload(
"https://storage.googleapis.com/download.tensorflow.org/data/creditcard.csv",
);
data = DataFrame(table)
first(data, 4)