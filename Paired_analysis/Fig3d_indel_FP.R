setwd("C://Temp/MRS_final/3a/whole_INDEL/")
library(viridis)
library(ggpubr)
library(stringr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpointdensity)
library(grid)


#==============MF_s_mx_tp_FPsha_count====================#
MF_s_mx_FP_df <- read.table("rep_3.MF_mx_FP_count_indel.txt", header = TRUE)
MF_s_mx_FP_df$case <- as.numeric(MF_s_mx_FP_df$case)
MF_s_mx_FP_df$control <- as.numeric(MF_s_mx_FP_df$control)
MF_s_mx_FP_df$case <- log10(((MF_s_mx_FP_df$case)+1))
MF_s_mx_FP_df$control <- log10(((MF_s_mx_FP_df$control)+1))
####################################################################
MF_s_mx_FP_somatic_df <- read.table("rep_3.MF_mx_FP_somatic_count_indel.txt", header = TRUE)
MF_s_mx_FP_somatic_df$case <- as.numeric(MF_s_mx_FP_somatic_df$case)
MF_s_mx_FP_somatic_df$control <- as.numeric(MF_s_mx_FP_somatic_df$control)
MF_s_mx_FP_somatic_df$case <- log10(((MF_s_mx_FP_somatic_df$case*100)+1))
MF_s_mx_FP_somatic_df$control <- log10(((MF_s_mx_FP_somatic_df$control*100)+1))

MF_s_FP_df <- bind_rows(MF_s_mx_FP_df,MF_s_mx_FP_somatic_df)
MF_s_FP_df_plot <- ggplot(data = MF_s_FP_df, aes(case, control)) +
  geom_pointdensity(size=1) +
scale_colour_gradientn(colors=c("#F5A600","#D60E00","#8F0A00"),breaks=c(0,1000,10000,50000,100000,150000), limits = c(1,150000)) +
  geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
  theme_bw() +#### white background
  xlab("case VAF (%)") + ylab("control VAF (%)") +
  scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
  scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
  coord_fixed() + ### for 1:1 ratio
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.title=element_blank(),  ###### hjust
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.title.align = 0.5,
        text = element_text(family = "sans"),
        legend.position = "none",
        panel.border = element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid = element_line(size = 0.4)) + ###### panel.grid
  ggtitle("MF Single")
# MF_s_FP_df_plot
png("output/3a_MF_s_FP_whole_INDEL.png",units = "in", width=3,height=3, res = 3600)
print(MF_s_FP_df_plot)
dev.off()


#==============MT_s_mx_tp_FPsha_count====================#
MT_s_mx_FP_df <- read.table("rep_4.MT_mx_FP_count_indel.txt", header = TRUE)
MT_s_mx_FP_df$case <- as.numeric(MT_s_mx_FP_df$case)
MT_s_mx_FP_df$control <- as.numeric(MT_s_mx_FP_df$control)
MT_s_mx_FP_df$case <- log10(((MT_s_mx_FP_df$case)+1))
MT_s_mx_FP_df$control <- log10(((MT_s_mx_FP_df$control)+1))
####################################################################
MT_s_mx_FP_somatic_df <- read.table("rep_4.MT_mx_FP_somatic_count_indel.txt", header = TRUE)
MT_s_mx_FP_somatic_df$case <- as.numeric(MT_s_mx_FP_somatic_df$case)
MT_s_mx_FP_somatic_df$control <- as.numeric(MT_s_mx_FP_somatic_df$control)
MT_s_mx_FP_somatic_df$case <- log10(((MT_s_mx_FP_somatic_df$case*100)+1))
MT_s_mx_FP_somatic_df$control <- log10(((MT_s_mx_FP_somatic_df$control*100)+1))
####################################################################
MT_s_tp_FP_df <- read.table("rep_4.MT_tp_FP_count_indel.txt", header = TRUE)
MT_s_tp_FP_df$case <- as.numeric(MT_s_tp_FP_df$case)
MT_s_tp_FP_df$control <- as.numeric(MT_s_tp_FP_df$control)
MT_s_tp_FP_df$case <- log10(((MT_s_tp_FP_df$case)+1))
MT_s_tp_FP_df$control <- log10(((MT_s_tp_FP_df$control)+1))
###################################################################
MT_s_tp_FP_somatic_df <- read.table("rep_4.MT_tp_FP_somatic_count_indel.txt", header = TRUE)
MT_s_tp_FP_somatic_df$case <- as.numeric(MT_s_tp_FP_somatic_df$case)
MT_s_tp_FP_somatic_df$control <- as.numeric(MT_s_tp_FP_somatic_df$control)
MT_s_tp_FP_somatic_df$case <- log10(((MT_s_tp_FP_somatic_df$case*100)+1))
MT_s_tp_FP_somatic_df$control <- log10(((MT_s_tp_FP_somatic_df$control*100)+1))
###################################################################
MT_s_FP_df <- bind_rows(MT_s_mx_FP_df,MT_s_mx_FP_somatic_df,MT_s_tp_FP_df,MT_s_tp_FP_somatic_df)  
MT_s_FP_df_plot <- ggplot(data = MT_s_FP_df, aes(case, control)) +
  geom_pointdensity(size=1) +
scale_colour_gradientn(colors=c("#F5A600","#D60E00","#8F0A00"),breaks=c(0,1000,10000,50000,100000,150000), limits = c(1,150000)) +
  geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
  theme_bw() +#### white background
  xlab("case VAF (%)") + ylab("control VAF (%)") +
  scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
  scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
  coord_fixed() + ### for 1:1 ratio
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.title=element_blank(),  ###### hjust
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.title.align = 0.5,
        text = element_text(family = "sans"),
        legend.position = "none",
        panel.border = element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid = element_line(size = 0.4)) + ###### panel.grid
  ggtitle("MT Single")
# MT_s_FP_df_plot
png("output/3a_MT_s_FP_whole_INDEL.png",units = "in", width=3,height=3, res = 3600)
print(MT_s_FP_df_plot)
dev.off()

####==============MT_p_mx_tp_FPsha_count====================#
MT_p_mx_FP_df <- read.table("rep_5.MT_P_mx_FP_count_indel.txt", header = TRUE)
MT_p_mx_FP_df$case <- as.numeric(MT_p_mx_FP_df$case)
MT_p_mx_FP_df$control <- as.numeric(MT_p_mx_FP_df$control)
MT_p_mx_FP_df$case <- log10(((MT_p_mx_FP_df$case)+1))
MT_p_mx_FP_df$control <- log10(((MT_p_mx_FP_df$control)+1))
###################################################################
MT_p_FP_df_plot <- ggplot(data = MT_p_mx_FP_df, aes(case, control)) +
  geom_pointdensity(size=1) +
scale_colour_gradientn(colors=c("#F5A600","#D60E00","#8F0A00"),breaks=c(0,1000,10000,50000,100000,150000), limits = c(1,150000)) +
  geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
  theme_bw() +#### white background
  xlab("case VAF (%)") + ylab("control VAF (%)") +
  scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
  scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
  coord_fixed() + ### for 1:1 ratio
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.title=element_blank(),  ###### hjust
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.title.align = 0.5,
        text = element_text(family = "sans"),
        legend.position = "none",
        panel.border = element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid = element_line(size = 0.4)) + ###### panel.grid
  ggtitle("MT Paired")
#MT_p_FP_df_plot
png("output/3a_MT_p_FP_whole_INDEL.png",units = "in", width=3,height=3, res = 3600)
print(MT_p_FP_df_plot)
dev.off()

#==============HC20_s_mx_tp_FPsha_count====================#
HC20_s_mx_FP_df <- read.table("rep_7.HC20_mx_FP_count_indel.txt", header = TRUE)
HC20_s_mx_FP_df$case <- as.numeric(HC20_s_mx_FP_df$case)
HC20_s_mx_FP_df$control <- as.numeric(HC20_s_mx_FP_df$control)
HC20_s_mx_FP_df$case <- log10(((HC20_s_mx_FP_df$case)+1))
HC20_s_mx_FP_df$control <- log10(((HC20_s_mx_FP_df$control)+1))
####################################################################
HC20_s_mx_FP_somatic_df <- read.table("rep_7.HC20_mx_FP_somatic_count_indel.txt", header = TRUE)
HC20_s_mx_FP_somatic_df$case <- as.numeric(HC20_s_mx_FP_somatic_df$case)
HC20_s_mx_FP_somatic_df$control <- as.numeric(HC20_s_mx_FP_somatic_df$control)
HC20_s_mx_FP_somatic_df$case <- log10(((HC20_s_mx_FP_somatic_df$case*100)+1))
HC20_s_mx_FP_somatic_df$control <- log10(((HC20_s_mx_FP_somatic_df$control*100)+1))
####################################################################
HC20_s_tp_FP_df <- read.table("rep_7.HC20_tp_FP_count_indel.txt", header = TRUE)
HC20_s_tp_FP_df$case <- as.numeric(HC20_s_tp_FP_df$case)
HC20_s_tp_FP_df$control <- as.numeric(HC20_s_tp_FP_df$control)
HC20_s_tp_FP_df$case <- log10(((HC20_s_tp_FP_df$case)+1))
HC20_s_tp_FP_df$control <- log10(((HC20_s_tp_FP_df$control)+1))
###################################################################
HC20_s_tp_FP_somatic_df <- read.table("rep_7.HC20_tp_FP_somatic_count_indel.txt", header = TRUE)
HC20_s_tp_FP_somatic_df$case <- as.numeric(HC20_s_tp_FP_somatic_df$case)
HC20_s_tp_FP_somatic_df$control <- as.numeric(HC20_s_tp_FP_somatic_df$control)
HC20_s_tp_FP_somatic_df$case <- log10(((HC20_s_tp_FP_somatic_df$case*100)+1))
HC20_s_tp_FP_somatic_df$control <- log10(((HC20_s_tp_FP_somatic_df$control*100)+1))
###################################################################
HC20_s_FP_df <- bind_rows(HC20_s_mx_FP_df,HC20_s_mx_FP_somatic_df,HC20_s_tp_FP_df,HC20_s_tp_FP_somatic_df)
# HC20_s_FP_df <- bind_rows(HC20_s_mx_FP_somatic_df,HC20_s_tp_FP_df,HC20_s_tp_FP_somatic_df)
HC20_s_FP_df_plot <- ggplot(data = HC20_s_FP_df, aes(case, control)) +
  geom_pointdensity(size=1) +
scale_colour_gradientn(colors=c("#F5A600","#D60E00","#8F0A00"),breaks=c(0,1000,10000,50000,100000,150000), limits = c(1,150000)) +
  geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
  theme_bw() +#### white background
  xlab("case VAF (%)") + ylab("control VAF (%)") +
  scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
  scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
  coord_fixed() + ### for 1:1 ratio
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.title=element_blank(),  ###### hjust
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.title.align = 0.5,
        text = element_text(family = "sans"),
        legend.position = "none",
        panel.border = element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid = element_line(size = 0.4)) + ###### panel.grid
  ggtitle("HC p.20")
# HC20_s_FP_df_plot
png("output/3a_HC20_FP_whole_INDEL.png",units = "in", width=3,height=3, res = 3600)
print(HC20_s_FP_df_plot)
dev.off()

#==============HC200_s_mx_tp_FPsha_count====================#
HC200_s_mx_FP_df <- read.table("rep_12.HC200_mx_FP_count_indel.txt", header = TRUE)
HC200_s_mx_FP_df$case <- as.numeric(HC200_s_mx_FP_df$case)
HC200_s_mx_FP_df$control <- as.numeric(HC200_s_mx_FP_df$control)
HC200_s_mx_FP_df$case <- log10(((HC200_s_mx_FP_df$case)+1))
HC200_s_mx_FP_df$control <- log10(((HC200_s_mx_FP_df$control)+1))
####################################################################
HC200_s_mx_FP_somatic_df <- read.table("rep_12.HC200_mx_FP_somatic_count_indel.txt", header = TRUE)
HC200_s_mx_FP_somatic_df$case <- as.numeric(HC200_s_mx_FP_somatic_df$case)
HC200_s_mx_FP_somatic_df$control <- as.numeric(HC200_s_mx_FP_somatic_df$control)
HC200_s_mx_FP_somatic_df$case <- log10(((HC200_s_mx_FP_somatic_df$case*100)+1))
HC200_s_mx_FP_somatic_df$control <- log10(((HC200_s_mx_FP_somatic_df$control*100)+1))
####################################################################
HC200_s_tp_FP_df <- read.table("rep_12.HC200_tp_FP_count_indel.txt", header = TRUE)
HC200_s_tp_FP_df$case <- as.numeric(HC200_s_tp_FP_df$case)
HC200_s_tp_FP_df$control <- as.numeric(HC200_s_tp_FP_df$control)
HC200_s_tp_FP_df$case <- log10(((HC200_s_tp_FP_df$case)+1))
HC200_s_tp_FP_df$control <- log10(((HC200_s_tp_FP_df$control)+1))
###################################################################
# HC200_s_tp_FP_somatic_df <- read.table("rep_12.HC200_tp_FP_somatic_count_indel.txt", header = TRUE)
# HC200_s_tp_FP_somatic_df$case <- as.numeric(HC200_s_tp_FP_somatic_df$case)
# HC200_s_tp_FP_somatic_df$control <- as.numeric(HC200_s_tp_FP_somatic_df$control)
# HC200_s_tp_FP_somatic_df$case <- log10(((HC200_s_tp_FP_somatic_df$case*100)+1))
# HC200_s_tp_FP_somatic_df$control <- log10(((HC200_s_tp_FP_somatic_df$control*100)+1))
###################################################################
# HC200_s_FP_df <- bind_rows(HC200_s_mx_FP_df,HC200_s_mx_FP_somatic_df,HC200_s_tp_FP_df,HC200_s_tp_FP_somatic_df)
HC200_s_FP_df <- bind_rows(HC200_s_mx_FP_df,HC200_s_mx_FP_somatic_df,HC200_s_tp_FP_df)
HC200_s_FP_df_plot <- ggplot(data = HC200_s_FP_df, aes(case, control)) +
  geom_pointdensity(size=1) +
scale_colour_gradientn(colors=c("#F5A600","#D60E00","#8F0A00"),breaks=c(0,1000,10000,50000,100000,150000), limits = c(1,150000)) +
  geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
  theme_bw() +#### white background
  xlab("case VAF (%)") + ylab("control VAF (%)") +
  scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
  scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
  coord_fixed() + ### for 1:1 ratio
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.title=element_blank(),  ###### hjust
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.title.align = 0.5,
        text = element_text(family = "sans"),
        legend.position = "none",
        panel.border = element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid = element_line(size = 0.4)) + ###### panel.grid
  ggtitle("HC p.200")
# HC200_s_FP_df_plot
png("output/3a_HC200_FP_whole_INDEL.png",units = "in", width=3,height=3, res = 3600)
print(HC200_s_FP_df_plot)
dev.off()



############## for border #####################


# 
# #==============MF_s_mx_tp_FPsha_count====================#
# MF_s_mx_FP_df <- read.table("rep_3.MF_mx_FP_count_indel.txt", header = TRUE)
# MF_s_mx_FP_df$case <- as.numeric(MF_s_mx_FP_df$case)
# MF_s_mx_FP_df$control <- as.numeric(MF_s_mx_FP_df$control)
# MF_s_mx_FP_df$case <- log10(((MF_s_mx_FP_df$case)+1))
# MF_s_mx_FP_df$control <- log10(((MF_s_mx_FP_df$control)+1))
# ####################################################################
# MF_s_mx_FP_somatic_df <- read.table("rep_3.MF_mx_FP_somatic_count_indel.txt", header = TRUE)
# MF_s_mx_FP_somatic_df$case <- as.numeric(MF_s_mx_FP_somatic_df$case)
# MF_s_mx_FP_somatic_df$control <- as.numeric(MF_s_mx_FP_somatic_df$control)
# MF_s_mx_FP_somatic_df$case <- log10(((MF_s_mx_FP_somatic_df$case*100)+1))
# MF_s_mx_FP_somatic_df$control <- log10(((MF_s_mx_FP_somatic_df$control*100)+1))
# 
# MF_s_FP_df <- bind_rows(MF_s_mx_FP_df,MF_s_mx_FP_somatic_df)
# MF_s_FP_df_plot <- ggplot(data = MF_s_FP_df, aes(case, control)) +
#   geom_pointdensity(size=1) +
#   scale_colour_gradientn(colors=c("#F5A600","#D60E00","#8F0A00"),breaks=c(0,1000,10000,50000,100000,150000), limits = c(1,150000)) +
#   geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
#   geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
#   theme_bw() +#### white background
#   xlab("case VAF (%)") + ylab("control VAF (%)") +
#   scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
#   scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(71),log10(101)),label=c("0","1","5","10","30","50","70","100"),limits = c(0,2.01)) +
#   coord_fixed() + ### for 1:1 ratio
#   theme(axis.text.x = element_text(size=6.5, angle = 45),
#         axis.text.y = element_text(size=6.5),
#         axis.title.x=element_blank(),
#         axis.title.y=element_blank(),
#         plot.title=element_text(size=13, face="bold", hjust = 0.5),  ###### hjust
#         panel.grid.minor = element_blank(),
#         legend.title = element_text(face = 'bold'),
#         legend.title.align = 0.5,
#         # legend.position = "none",
#         text = element_text(family = "sans"),
#         panel.grid = element_line(size = 0.1)) + ###### panel.grid
#   ggtitle("MF Single")
# # MF_s_FP_df_plot
# pdf("for_FP_legend_INDEL.pdf",width = 4, height = 4)
# print(MF_s_FP_df_plot)
# dev.off()

























