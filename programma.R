# Ielādē nepieciešamās bibliotēkas
library(ggplot2)

file_list <- list.files(pattern = "variants[0-9]+\\.txt")
file_list <- file_list[file_list != "variants12.txt"]
