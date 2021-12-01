library(ggplot2)
library(ggpointdensity)
library(ggnewscale)
library(scales)
library(viridis)


cur_time <- as.character(Sys.time())
cur_time <- gsub(" ", "_", cur_time)

in_dir <- "/home/data/project/MRS/Figure/1b/data"
out_dir <- "/home/data/project/MRS/Figure/1b/plots"
adj <- 0.1
scale_lim <- 6e5
out_file <- paste0(out_dir, "/1b.pc.hc.dup.adj_", adj, ".", cur_time)
options(bitmapType = "cairo")


load_input <- function(in_file) {
    cat(paste0("Loading ", in_file, "...\n"))
    in_df <- read.csv(in_file, header = T, sep = "\t")
    in_df["log_case"] <- log10(in_df$X.CASE_AF * 100 + 1)
    in_df["log_ctrl"] <- log10(in_df$CTRL_AF * 100 + 1)
    print(str(in_df))
    return(in_df)
}

pc <- load_input(paste0(in_dir, "/all_samp_mer.pc_all.hc.dup_paired.txt"))
ans <- read.csv(paste0(in_dir, "/pc.exp.txt"), header = FALSE, sep = "\t")
ans["log_case"] <- log10(ans$V2 + 1)
ans["log_ctrl"] <- log10(ans$V3 + 1)
uniq <- subset(pc, pc$log_case == 0 | pc$log_ctrl == 0)
share <- subset(pc, pc$log_case != 0 & pc$log_ctrl != 0)
print(dim(uniq))
print(dim(share))


 p <- ggplot() +
    geom_pointdensity(data = uniq, aes(x = log_case, y = log_ctrl),
                      size = 1.3, alpha = 0.3, shape = 16, adjust = adj, show.legend = TRUE) +
    scale_color_viridis_c(direction = -1, limits = c(NA, scale_lim), labels = label_scientific()) +
    new_scale_color() + 
    geom_pointdensity(data = share, mapping = aes(x = log_case, y = log_ctrl),
                      size = 1.3, alpha = 0.3, shape = 16, , adjust = adj, show.legend = FALSE, inherit.aes = FALSE) +
    scale_color_viridis_c(direction = -1, limits = c(NA, scale_lim)) +
    geom_point(data = ans, aes(x = log_case, y = log_ctrl, fill = "NA"), shape = 21, size = 2, color = "black", fill = "NA", stroke = 1, alpha = 0.7) +
    labs(title = "Distribution of paired mosaic variant allele frequency", x = "Case VAF (M3)", y = "Control VAF (M1, M2)")
p <- p + geom_vline(xintercept = log10(11), linetype = 2) + geom_hline(yintercept = log10(11), linetype = 2)

cat("Adding plot themes...\n")
lim_vec <- c(0, log10(101))
break_vec <- c(log10(2), log10(6), log10(11), log10(21), log10(31), log10(51), log10(71))
lab_vec <- c("1%", "5%", "10%", "20%", "30%", "50%", "70%")

p <- p + theme_bw() + theme(panel.grid.minor = element_blank(), panel.grid.major = element_line(size = 0.4)) +
    scale_x_continuous(limits = lim_vec, breaks = break_vec, label = lab_vec) +
    scale_y_continuous(limits = lim_vec, breaks = break_vec, label = lab_vec) +
    theme(axis.text.x = element_text(size = rel(2), angle = 45, vjust = 0.5),
        axis.text.y = element_text(size = rel(2), vjust = 0.5),
        axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16),
        plot.title = element_text(size = 16),
        aspect.ratio = 1
    )

ggsave(paste0(out_file, ".png"))
ggsave(paste0(out_file, ".pdf"))
