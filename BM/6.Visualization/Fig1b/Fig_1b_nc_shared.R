library(ggplot2)
library(ggpointdensity)
library(ggnewscale)
library(scales)
library(viridis)


cur_time <- as.character(Sys.time())
cur_time <- gsub(" ", "_", cur_time)

in_dir <- "/home/data/project/MRS/Figure/1b/data"
out_dir <- "/home/data/project/MRS/Figure/1b/plots"
adj <- 0.5
scale_lim <- 45e5
nc_ds <- "ds_1k"
out_file <- paste0(out_dir, "/1b.nc.hc.dup.", nc_ds, ".adj_", adj, ".", cur_time)
options(bitmapType = "cairo")


load_input <- function(in_file) {
    cat(paste0("Loading ", in_file, "...\n"))
    in_df <- read.csv(in_file, header = T, sep = "\t")
    in_df["log_case"] <- log10(in_df$X.CASE_AF * 100 + 1)
    in_df["log_ctrl"] <- log10(in_df$CTRL_AF * 100 + 1)
    print(str(in_df))
    return(in_df)
}

nc_low <- load_input(paste0(in_dir, "/all_samp_mer.nc_low.hc.dup_paired.", nc_ds, ".txt"))
nc_high <- load_input(paste0(in_dir, "/all_samp_mer.nc_germline.hc.dup_paired.", nc_ds, ".txt"))
nc <- rbind(nc_low, nc_high)
uniq <- subset(nc, nc$log_case == 0 | nc$log_ctrl == 0)
share <- subset(nc, nc$log_case != 0 & nc$log_ctrl != 0)
print(dim(uniq))
print(dim(share))


 p <- ggplot() +
    geom_pointdensity(data = share, aes(x = log_case, y = log_ctrl),
                      size = 0.2, alpha = 0.3, adjust = adj, show.legend = TRUE) +
    scale_color_gradientn(colors = c("#F5A600", "#D60E00", "#8F0A00"), limits = c(NA, scale_lim), labels = label_scientific()) +
    new_scale_color() + 
    geom_pointdensity(data = uniq, mapping = aes(x = log_case, y = log_ctrl),
                      size = 0.2, alpha = 0.3, adjust = adj, show.legend = FALSE, inherit.aes = FALSE) +
    scale_color_gradientn(colors = c("#F5A600", "#D60E00", "#8F0A00"), limits = c(NA, scale_lim)) +
    labs(title = "Distribution of paired control variant allele frequency", x = "Case VAF (M3)", y = "Control VAF (M1, M2)")
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
