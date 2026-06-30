# ============================================================
# Boxplot
# ============================================================

p_box <- ggplot(df, aes(x = group, y = value, fill = group)) +
  geom_boxplot(width = 0.6, outlier.shape = NA, alpha = 0.7) +
  geom_jitter(width = 0.15, size = 1.8, alpha = 0.6) +
  labs(
    title = "Boxplot",
    x = "Group",
    y = "Value"
  ) +
  theme_my +
  theme(legend.position = "none")

p_box
