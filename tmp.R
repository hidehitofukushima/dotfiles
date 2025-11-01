
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


# > df
# # A tibble: 251 × 60
#    sample         chr1p_LOSSes chr13q_GAINs chr2q_GAINs chr8p_LOSSes chr8p_GAINs
#    <chr>                 <dbl>        <dbl>       <dbl>        <dbl>       <dbl>
#  1 AR-ML-0201-T-…           NA           NA          NA           NA          NA
#  2 AR-ML-0174-T-…           NA           NA           2            3          NA
#  3 AR-ML-0195-T-…            3           NA          NA           NA          NA
#  4 AR-ML-0001-T-…           NA            2           2           NA          NA
#  5 AR-ML-0011-T-…           NA           NA          NA           NA          NA
#  6 AR-ML-0019-T-…            5           NA           5           NA          NA
#  7 AR-ML-0040-T-…           NA           NA           1            5           5
#  8 AR-ML-0156-T-…            3           NA          NA            3          NA
#  9 AR-ML-0192-T-…           NA           NA          NA           NA          NA
# 10 AR-ML-0207-T-…            3           NA          NA           NA          NA
#

df <- df %>% 
	mutate(sample_short = strsplit(sample, "-")[[1]][1])
