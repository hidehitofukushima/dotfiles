library(ggplot2)

p_count <- ggplot(df, aes(x = group, fill = group)) +
  geom_bar(width = 0.65, alpha = 0.8) +
  labs(
    title = "Count by group",
    x = "Group",
    y = "Count"
  ) +
  theme_bw() +
  theme(legend.position = "none")

p_count
