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

# 4. Izvada faktoru līmeņu kopsavilkumu uz failu results.txt
summary_table <- summary(kordat[, 9:ncol(kordat)])
write.table(summary_table, file = "results.txt", append = FALSE, sep = "\t", col.names = NA)

# 5. Saskalda Slope kolonnu sarakstā pēc b faktora vērtībām un saglabā to sl.by.b
sl.by.b <- split(kordat$Slope, kordat$b)
write.table(sl.by.b, file = "results.txt", append = TRUE, sep = "\t", col.names = NA)

# 6. Izveido jaunu kolonnu "Average", kas satur vidējo no "Slope", "Intercept" un "adj.r.squared"
kordat$Average <- rowMeans(kordat[, c("Slope", "Intercept", "adj.r.squared")])

# 7. Aprēķina standartnovirzi pēc f faktora līmeņiem un izvada to failā
std_dev_by_f <- aggregate(kordat$Intercept, by = list(kordat$f), FUN = sd)
colnames(std_dev_by_f) <- c("f_factor", "std_dev")
write.table(std_dev_by_f, file = "results.txt", append = TRUE, sep = "\t", col.names = NA)

# 8. Atlasīt tikai rindiņas, kur adj.r.squared > 0.7, un saglabā tās prockordat
tprockordat <- subset(kordat, adj.r.squared > 0.7)

# 9. Pārraksta "Slope" kolonnas vērtību, izmantojot formulu 1 - 1/k
prockordat$Slope <- 1 - 1/prockordat$Slope

# 10. Izdrukā prockordat datnē results.txt
write.table(prockordat, file = "results.txt", append = TRUE, sep = "\t", col.names = NA)

# 11. Izveido izkliedes grafiku (MAD vs. Average) un saglabā to scatter.svg
scatter_plot <- ggplot(kordat, aes(x = MAD, y = Average)) +
  geom_point() +
  labs(title = "Scatter plot", x = "MAD", y = "Average")
ggsave("scatter.svg", plot = scatter_plot)

# 12. Izveido kastu grafiku no "Intercept" datiem, grupējot pēc f faktora, un saglabā to boxplot.svg
box_plot <- ggplot(kordat, aes(x = f, y = Intercept, fill = f)) +
  geom_boxplot() +
  labs(title = "Boxplot by f factor", x = "f Factor", y = "Intercept")
ggsave("boxplot.svg", plot = box_plot)

# Atrast biežāko faktoru līmeni
most_common_level <- names(which.max(table(kordat$f)))
filtered_prockordat <- prockordat[grep(most_common_level, rownames(prockordat)), ]
print(filtered_prockordat)
