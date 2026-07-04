library(tidyr)

long <- df |>
  pivot_longer(
    cols = starts_with("gene_"),
    names_to = "gene",
    values_to = "expression"
  )

long
