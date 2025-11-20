###########################################
# packages
###########################################
library(tidyverse)
library(stringr)

###########################################
# files
###########################################


file <- "~/Desktop/Projects_wgs_ddd/COMPLEXHEATMAP/ONCOPLOT_v2/output_v2/ML-01/no1_oncoplot_mat.xlsx"

df <- readxl::read_xlsx(file)
df <- df %>%
  mutate(sample_short = strsplit(sample, "-")[[1]][1])


for (i in seq_along(df$sample)) {
  print(i)
}
seq_along(10:14)
seq_len(10)

df <- readxl::read_xls






###########################################
# gaussian process)
###########################################
library(mgcv)
library(ggplot2)

# data
set.seed(123)
x <- runif(100)
y <- x + rnorm(100, sd = 0.5)

# fit
fit <- gam(y ~ s(x), method = "REML")
plot(fit)

# predict
x_new <- seq(0, 1, length.out = 100)
y_new <- predict(fit, newdata = data.frame(x = x_new))

# plot
ggplot(data.frame(x = x, y = y), aes(x, y)) +
  geom_point() +
  geom_line(data = data.frame(x = x_new, y = y_new), aes(x, y))









cairo_pdf("tmp.pdf", width = 8, height = 6)
cairo_pdf(
  filename = "tmp.pdf",
  width = 7,
  height = 6,
  family = "Helvetica",
  pointsize = 12
)
plot(1:10)
text(5, 5, "福島英人です")
dev.off()


quartz(type = "pdf", width = 7, height = 5, file = "hoge.pdf")
plot(1:10)
text(5, 5, "福島英人です")
dev.off()
