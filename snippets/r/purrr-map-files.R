library(purrr)
library(readr)
library(dplyr)

files <- list.files("data", pattern = "\\.tsv$", full.names = TRUE)

df <- files |>
  set_names() |>
  map_dfr(read_tsv, show_col_types = FALSE, .id = "source_file")

df
