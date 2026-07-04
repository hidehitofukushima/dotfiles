my_function <- function(x, na_rm = TRUE) {
  stopifnot(is.numeric(x))
  mean(x, na.rm = na_rm)
}

my_function(c(1, 2, NA, 4))
