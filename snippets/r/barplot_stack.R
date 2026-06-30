# ============================================================
# Stacked barplot
# ============================================================

p_stacked <- ggplot(df, aes(x = group, fill = sex)) +
  geom_bar(position = "stack", width = 0.65, alpha = 0.85) +
  labs(
    title = "Stacked barplot",
    x = "Group",
    y = "Count",
    fill = "Sex"
  ) +
  theme_my

p_stacked
