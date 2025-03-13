# Ielādē nepieciešamās bibliotēkas
tlibrary(ggplot2)

# 1. Dzēš visus variantsNN.txt failus, izņemot variants12.txt
file_list <- list.files(pattern = "variants[0-9]+\\.txt")
file_list <- file_list[file_list != "variants12.txt"]
file.remove(file_list)

# 2. Ielasa teksta datni (variants12.txt) un saglabā to datu satvarā kordat
kordat <- read.table("variants12.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE, strip.white = TRUE)

# 3. Pārveido kolonnas no 9. un uz augšu par faktoriem
kordat[, 9:ncol(kordat)] <- lapply(kordat[, 9:ncol(kordat)], factor)