
library(ggplot2)

file_list <- list.files(pattern = "variants[0-9]+\\.txt")
file_list <- file_list[file_list != "variants12.txt"]
file.remove(file_list)

kordat <- read.table("variants12.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE, strip.white = TRUE)
kordat[, 9:ncol(kordat)] <- lapply(kordat[, 9:ncol(kordat)], factor)

summary_table <- summary(kordat[, 9:ncol(kordat)])
write.table(summary_table, file = "results.txt", append = FALSE, sep = "\t", col.names = NA)
