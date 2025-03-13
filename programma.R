# Ielādē nepieciešamās bibliotēkas
library(ggplot2)

file_list <- list.files(pattern = "variants[0-9]+\\.txt")
file_list <- file_list[file_list != "variants12.txt"]
file.remove(file_list)

kordat <- read.table("variants12.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE, strip.white = TRUE)
kordat[, 9:ncol(kordat)] <- lapply(kordat[, 9:ncol(kordat)], factor)

summary_table <- summary(kordat[, 9:ncol(kordat)])
write.table(summary_table, file = "results.txt", append = FALSE, sep = "\t", col.names = NA)

sl.by.b <- split(kordat$Slope, kordat$b)
write.table(sl.by.b, file = "results.txt", append = TRUE, sep = "\t", col.names = NA)

kordat$Average <- rowMeans(kordat[, c("Slope", "Intercept", "adj.r.squared")])

std_dev_by_f <- aggregate(kordat$Intercept, by = list(kordat$f), FUN = sd)
colnames(std_dev_by_f) <- c("f_factor", "std_dev")
write.table(std_dev_by_f, file = "results.txt", append = TRUE, sep = "\t", col.names = NA)

prockordat <- subset(kordat, adj.r.squared > 0.7)
prockordat$Slope <- 1 - 1/prockordat$Slope
write.table(prockordat, file = "results.txt", append = TRUE, sep = "\t", col.names = NA)

scatter_plot <- ggplot(kordat, aes(x = MAD, y = Average)) +
  geom_point() +
  labs(title = "Scatter plot", x = "MAD", y = "Average")
ggsave("scatter.svg", plot = scatter_plot)

box_plot <- ggplot(kordat, aes(x = f, y = Intercept, fill = f)) +
  geom_boxplot() +
  labs(title = "Boxplot by f factor", x = "f Factor", y = "Intercept")
ggsave("boxplot.svg", plot = box_plot)

most_common_level <- names(which.max(table(kordat$f)))
filtered_prockordat <- prockordat[grep(most_common_level, rownames(prockordat)), ]
print(filtered_prockordat)
