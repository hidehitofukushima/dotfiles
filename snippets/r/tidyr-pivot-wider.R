library(tidyr)

wide <- long |>
  pivot_wider(
    names_from = gene,
    values_from = expression
  )

wide
