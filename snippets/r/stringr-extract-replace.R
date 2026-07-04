library(dplyr)
library(stringr)

out <- df |>
  mutate(
    sample_num = str_extract(sample_id, "[0-9]+"),
    clean_name = str_replace_all(sample_id, "-", "_")
  )

out
