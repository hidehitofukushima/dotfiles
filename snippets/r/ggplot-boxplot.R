library(ggplot2)

p_box <- ggplot(df, aes(x = group, y = value, fill = group)) +
  geom_boxplot(outlier.alpha = 0.4) +
  geom_jitter(width = 0.15, alpha = 0.5, size = 1.5) +
  labs(
    title = "Value by group",
    x = "Group",
    y = "Value"
  ) +
  theme_bw() +
  theme(legend.position = "none")

p_box
