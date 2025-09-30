library(tidyverse)
library(readr)
file <- "tmp.csv"
df <- read_csv(file, col_names = FALSE)
print(df)


df %>%
  mutate(id = row_number()) %>%
  write_csv("tmp2.csv")
df %>%
  mutate(idk = row_number()) %>%
  write_csv("tmp3.csv")



df2 <- read_csv(file, col_names = TRUE)
colnames(df2)
