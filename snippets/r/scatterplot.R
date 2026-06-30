# ============================================================
# Scatter plot
# ============================================================

p_scatter <- ggplot(df, aes(x = age, y = value, color = group)) +
  geom_point(size = 2.2, alpha = 0.75) +
  labs(
    title = "Scatter plot",
    x = "Age",
    y = "Value",
    color = "Group"
  ) +
  theme_my

p_scatter
