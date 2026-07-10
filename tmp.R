
# "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"
suppressPackageStartupMessages({
  library(ggplot2)
})

p = ggplot(iris, aes(x = Sepal.Length, y = Petal.Length)) +
  geom_point() +
  theme_classic()

print(p) <- %>% <- %>% <- %>% 
library(tidyverse)
filelist <- list.files(path = "./", pattern = "tsv", full.names = TRUE, recursive = TRUE)

dflist <- lapply(filelist, function(x) {
                   sample_id <- strsplit(x, "/")[[1]][5]
                   print(sample_id)
                   df <- read_tsv(x, col_names = TRUE) %>%
                     mutate(sample_id = sample_id) %>%
                     select(sample_id, everything())
                   df
})
dflist2 <- dflist[lengths(lapply(dflist, nrow)) > 0]
dflist2 <- lapply(dflist2, function(x) {
                    x$Pos_1 <- as.numeric(x$Pos_1)
                    x$Pos_2 <- as.numeric(x$Pos_2)
                    x$Inserted_Length <- as.numeric(x$Inserted_Length)
                    x$SV_Length <- as.numeric(x$SV_Length)
                    x$QUAL <- as.numeric(x$QUAL)
                    x$nVF <- as.numeric(x$nVF)
                    x$tVF <- as.numeric(x$tVF)
                    x$nREF <- as.numeric(x$nREF)
                    x$tREF <- as.numeric(x$tREF)
                    x$nREFPAIR <- as.numeric(x$nREFPAIR)
                    x$tREFPAIR <- as.numeric(x$tREFPAIR)
                    x$nVAF <- as.numeric(x$nVAF)
                    x$tVAF <- as.numeric(x$tVAF)
                    x
})

df <- dplyr::bind_rows(dflist2)
#
write_tsv(df, "aggregated_AL-01.tsv")



