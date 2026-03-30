### =========================================
### FOOL-PROOF TREE + MAP SCRIPT
### =========================================

# 1. Install packages once if needed
# install.packages(c("ape", "maps", "mapdata"))

# 2. Load packages
library(ape)
library(maps)
library(mapdata)

# 3. Reset plotting completely
graphics.off()

# 4. Define a simple tree
tree_str <- "((Indirana_chiravasi_ch_ab1:0.02,Indirana_chiravasi_cr_ab1:0.02):0.01,
((Indirana_chiravasi_ti_ab1:0.01,Indirana_chiravasi_sw_ab1:0.01):0.01,
(Indirana_salelkari_ka_ab1:0.02,Indirana_salelkari_jo_ab1:0.02):0.01):0.02,
(Indirana_duboisi_ajasra_ab1:0.03,Indirana_duboisi_kig_ab1:0.03):0.02,
(Indirana_tysoni_kur_ab1:0.03,Indirana_duboisi_bg_ab1:0.03):0.02);"

tree <- read.tree(text = tree_str)

# 5. Check the tip labels
print(tree$tip.label)

# 6. Create coordinates for each tip
# IMPORTANT:
# - row names must match tree$tip.label exactly
# - column names should be lat and long
coords <- data.frame(
  lat = c(15.95, 15.96, 15.80, 15.70, 15.40, 15.35, 14.20, 13.90, 12.90, 12.70),
  long = c(74.00, 74.02, 74.10, 74.20, 74.35, 74.40, 74.80, 75.10, 75.40, 75.50),
  row.names = tree$tip.label
)

# 7. Quick checks
print(nrow(coords))
print(length(tree$tip.label))
print(identical(rownames(coords), tree$tip.label))
print(coords)

# 8. Assign colors by species
tip_cols <- ifelse(grepl("chiravasi", tree$tip.label), "red",
                   ifelse(grepl("salelkari", tree$tip.label), "forestgreen",
                          ifelse(grepl("duboisi", tree$tip.label), "blue", "purple")))

# 9. Open a PDF device so output is definitely saved
pdf("indirana_tree_map.pdf", width = 12, height = 6)

# 10. Split plotting area into two panels
layout(matrix(c(1,2), nrow = 1), widths = c(1, 1.2))

# 11. Left panel: phylogenetic tree
par(mar = c(4, 2, 3, 1))
plot(tree,
     main = "Phylogenetic tree",
     cex = 0.8,
     tip.color = tip_cols,
     no.margin = FALSE)

# 12. Right panel: map + localities
par(mar = c(4, 4, 3, 1))
map("worldHires",
    xlim = c(73.5, 76.0),
    ylim = c(12.0, 16.5),
    col = "black",
    fill = FALSE,
    mar = c(4,4,3,1))

points(coords$long, coords$lat,
       pch = 21,
       bg = tip_cols,
       col = "black",
       cex = 1.5)

text(coords$long, coords$lat,
     labels = seq_len(nrow(coords)),
     pos = 4,
     cex = 0.7)

title("Sampling localities")

# 13. Add legend
legend("bottomleft",
       legend = c("chiravasi", "salelkari", "duboisi", "tysoni"),
       pt.bg = c("red", "forestgreen", "blue", "purple"),
       pch = 21,
       bty = "n",
       cex = 0.8)

# 14. Close PDF
dev.off()

# 15. Also draw to screen
graphics.off()
layout(matrix(c(1,2), nrow = 1), widths = c(1, 1.2))

par(mar = c(4, 2, 3, 1))
plot(tree,
     main = "Phylogenetic tree",
     cex = 0.8,
     tip.color = tip_cols,
     no.margin = FALSE)

par(mar = c(4, 4, 3, 1))
map("worldHires",
    xlim = c(73.5, 76.0),
    ylim = c(12.0, 16.5),
    col = "black",
    fill = FALSE)

points(coords$long, coords$lat,
       pch = 21,
       bg = tip_cols,
       col = "black",
       cex = 1.5)

text(coords$long, coords$lat,
     labels = seq_len(nrow(coords)),
     pos = 4,
     cex = 0.7)

title("Sampling localities")

legend("bottomleft",
       legend = c("chiravasi", "salelkari", "duboisi", "tysoni"),
       pt.bg = c("red", "forestgreen", "blue", "purple"),
       pch = 21,
       bty = "n",
       cex = 0.8)
