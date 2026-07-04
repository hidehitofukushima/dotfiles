library(purrr)
library(readr)
library(dplyr)

files <- list.files("data", pattern = "\\.csv$", full.names = TRUE)

df <- files |>
  set_names(basename) |>
  map_dfr(~ read_csv(.x, show_col_types = FALSE), .id = "file")

df
