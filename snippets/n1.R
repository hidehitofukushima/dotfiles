# source('hoge.R')
# or
# Rscript hoge.R

# ============================================================
# package
# ============================================================

suppressPackageStartupMessages({
	library(tidyverse)
})


# ============================================================
# data frame
# ============================================================



# ============================================================
# 
# ============================================================




my_function <- function(x, na_rm = TRUE) {
  stopifnot(is.numeric(x))
  mean(x, na.rm = na_rm)
}

my_function(c(1, 2, NA, 4))

files <- list.files(
  path = ".",
  pattern = "\\.R$",
  recursive = TRUE,
  full.names = TRUE
)

files

