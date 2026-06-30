# ============================================================
# 100% stacked barplot
# ============================================================

p_stacked_100 <- ggplot(df, aes(x = group, fill = sex)) +
  geom_bar(position = "fill", width = 0.65, alpha = 0.85) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(
    title = "100% stacked barplot",
    x = "Group",
    y = "Proportion",
    fill = "Sex"
  ) +
  theme_my

p_stacked_100
