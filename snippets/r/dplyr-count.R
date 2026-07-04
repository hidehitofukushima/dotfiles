library(dplyr)

counts <- df |>
  count(group, sort = TRUE)

counts
