library(tidyverse)
library(packages)
library(air)

file <- "nvim/init.lua"
df <-  read_tsv(df, col_names = TRUE, col_types = FALSE, id = FALSE)
df <- read_tsv(file, col_names = TRUE, col_types = FALSE)

