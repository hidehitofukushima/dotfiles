library(dplyr)

out <- df |>
  left_join(annotation, by = "sample_id")

out
