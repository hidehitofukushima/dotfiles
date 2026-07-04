library(readr)

df_csv <- read_csv("input.csv", show_col_types = FALSE)
df_tsv <- read_tsv("input.tsv", show_col_types = FALSE)

df_tsv
