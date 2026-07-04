library(dplyr)
library(forcats)

df2 <- df |>
  mutate(group = fct_reorder(group, value, .fun = median, na.rm = TRUE))

df2
