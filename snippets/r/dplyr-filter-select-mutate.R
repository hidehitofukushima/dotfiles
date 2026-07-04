library(dplyr)

out <- df |>
  filter(group == "A", value >= 10) |>
  mutate(
    log_value = log1p(value),
    flag = value >= 20
  ) |>
  select(sample_id, group, value, log_value, flag)

out
