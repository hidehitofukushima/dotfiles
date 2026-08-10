suppressPackageStartupMessages({
  library(ggplot2)
  library(reshape2)
  library(RColorBrewer)
})

library(ggplot2)

p <- ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, color = Species)) +
  geom_point(alpha = 0.8, size = 2) +
  labs(
    title = "Scatter plot",
    x = "X",
    y = "Y",
    color = "Group"
  ) +
  theme_bw()

p
ggsave(p)
ggsave("tmp.pdf")
library(ggplot2)

p <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) + geom_p int(alpha = 0.8, size = 2) +
  labs(
    title = "Scatter plot",
    x = "X",
    y = "Y",
    color = "Group"
  ) +
  theme_bw()

p
p
data <- matrix(rnorm(100), ncol = 5)
colnames(data) <- c("A", "B", "C", "D", "E")
rownames(data) <- paste0("gene", 1:nrow(data))
df           <- melt(data)

colnames(df) <- c("Gene", "Group", "Value")
head(df)

dev.new()
clr <- heatmap(data, scale = "none")
dev.off()

gene.idx  <- rownames(data)[clr$rowInd]
group.idx <- colnames(data)[clr$colInd]

df$Gene  <- factor(df$Gene, levels = gene.idx)
df$Group <- factor(df$Group, levels = group.idx)
ghm <- ggplot(df, aes(x = Group, y = Gene, fill = Value))
ghm <- ghm + geom_tile()
ghm <- ghm + theme_bw()
ghm <- ghm + theme(plot.background = element_blank(),
                   panel.grid.minor = element_blank(),
                   panel.grid.major = element_blank(),
                   panel.background = element_blank(),
                   axis.line = element_blank(),
                   axis.ticks = element_blank(),
                   strip.background = element_rect(fill = "white", colour = "white"),
                   axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
ghm <- ghm + scale_fill_gradientn("value", colours = rev(brewer.pal(9, "Spectral")), na.value = "white")
ghm <- ghm + xlab("Group") + ylab("Gene")
ghm
p
clr
dev.new()
clr <- heatmap(data, scale = "none")
dev.off()
dev.off()
tim
Sys.sleep(10)
iris
