library(dplyr)

summary <- df |>
  group_by(group) |>
  summarise(
    n = n(),
    mean_value = mean(value, na.rm = TRUE),
    median_value = median(value, na.rm = TRUE),
    sd_value = sd(value, na.rm = TRUE),
    .groups = "drop"
  )

summary
