# ============================================================
# Barplot: mean ± SE
# ============================================================

summary_df <- df |>
  group_by(group) |>
  summarise(
    n = n(),
    mean = mean(value, na.rm = TRUE),
    sd = sd(value, na.rm = TRUE),
    se = sd / sqrt(n),
    .groups = "drop"
  )

p_bar <- ggplot(summary_df, aes(x = group, y = mean, fill = group)) +
  geom_col(width = 0.65, alpha = 0.8) +
  geom_errorbar(
    aes(ymin = mean - se, ymax = mean + se),
    width = 0.2,
    linewidth = 0.7
  ) +
  labs(
    title = "Barplot: mean ± SE",
    x = "Group",
    y = "Mean value"
  ) +
  theme_my +
  theme(legend.position = "none")

p_bar
