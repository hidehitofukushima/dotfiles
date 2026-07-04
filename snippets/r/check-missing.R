library(dplyr)

missing_summary <- df |>
  summarise(across(everything(), ~ sum(is.na(.x)))) |>
  tidyr::pivot_longer(
    cols = everything(),
    names_to = "column",
    values_to = "n_missing"
  ) |>
  arrange(desc(n_missing))

missing_summary
