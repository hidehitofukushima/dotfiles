library(tidyverse)
iris |> group_by(Species) |>
	summarise(
						n=n(),
						mean = mean(Sepal.Length),
						median = median(Sepal.Length, na.rm = TRUE),
						sd = sd(Sepal.Length, na.rm = TRUE),
						.groups = "drop"
						) -> iris_summary

suppressPackageStartupMessages({
  library(tidyverse)
  library(readxl)
})


# ============================================================
# Scatter plot
# ============================================================

# "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"
p_scatter <- ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Species)) +
  geom_point(size = 2.2, alpha = 0.75) +
  labs(
    title = "Scatter plot",
    x = "Age",
    y = "Value",
    color = "Group"
  ) +
  theme_classic()


library(svglite)
ggsave(filename="./output_file.svg", plot=p_scatter, width=10, height=3, dpi=300, units="in", device="svg")
