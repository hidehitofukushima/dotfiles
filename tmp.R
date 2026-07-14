
# "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"
suppressPackageStartupMessages({
  library(ggplot2)
})

p = ggplot(iris, aes(x = Sepal.Length, y = Petal.Length)) +
  geom_point() +
  theme_classic()

print(p)



