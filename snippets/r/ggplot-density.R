library(ggplot2)

p_density <- ggplot(df, aes(x = value, fill = group)) +
  geom_density(alpha = 0.4) +
  labs(
    title = "Density plot",
    x = "Value",
    y = "Density"
  ) +
  theme_bw()

p_density
