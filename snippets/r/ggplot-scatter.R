library(ggplot2)

p <- ggplot(df, aes(x = x, y = y, color = group)) +
  geom_point(alpha = 0.8, size = 2) +
  labs(
    title = "Scatter plot",
    x = "X",
    y = "Y",
    color = "Group"
  ) +
  theme_bw()

p
