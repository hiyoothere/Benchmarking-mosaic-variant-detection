setwd("C://Temp/MRS_final/3a/whole_INDEL/")
library(viridis)
library(ggpubr)
library(stringr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpointdensity)
library(grid)
################################################################################

#################################################################################################################
#===============MF_s_mx_TP_sensitivity==============#
MF_s_mx_TP_df <- read.table("3.MF_tp_TP_sensitivity_indel.txt", header = TRUE)
MF_s_mx_TP_df <- separate(data=MF_s_mx_TP_df, col= case.control, sep=",", into = c("case","control"))
MF_s_mx_TP_df$case <- as.numeric(MF_s_mx_TP_df$case)
MF_s_mx_TP_df$control <- as.numeric(MF_s_mx_TP_df$control)
MF_s_mx_TP_df$case <- log10(((MF_s_mx_TP_df$case*100)+1))
MF_s_mx_TP_df$control <- log10(((MF_s_mx_TP_df$control*100)+1))
######################################################################################################################
MF_s_mx_TP_somatic_df <- read.table("3.MF_tp_TP_somatic_sensitivity_indel.txt", header = TRUE)
MF_s_mx_TP_somatic_df <- separate(data=MF_s_mx_TP_somatic_df, col= case.control, sep=",", into = c("case","control"))
MF_s_mx_TP_somatic_df$case <- as.numeric(MF_s_mx_TP_somatic_df$case)
MF_s_mx_TP_somatic_df$control <- as.numeric(MF_s_mx_TP_somatic_df$control)
MF_s_mx_TP_somatic_df$case <- log10(((MF_s_mx_TP_somatic_df$case*100)+1))
MF_s_mx_TP_somatic_df$control <- log10(((MF_s_mx_TP_somatic_df$control*100)+1))
######################################################################################################################
MF_s_mx_TP_all_df <- bind_rows(MF_s_mx_TP_df,MF_s_mx_TP_somatic_df)
######################################################################################################################
MF_s_mx_TPplot <- ggplot() +
  geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_point(data = MF_s_mx_TP_all_df, aes(case, control, fill = sensitivity),size=5,shape=21,color="black",stroke = 0.5) +
  scale_fill_gradientn(colors=c("white","#FDE725FF","#B8DE29FF","#73D055FF","#55C667FF","#29AF7FFF","#1F968BFF","#238A8DFF","#2D708EFF","#39568CFF","#404788FF","#482677FF","#440154FF"),values = c(0.0,0.5,1.0), breaks=c(0.25,0.50,0.75), limits=c(0,1)) +
  theme_bw() +#### white background 
  xlab("case VAF (%)") + ylab("control VAF (%)") +
  scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(101)),label=c("0","1","5","10","30","50","100"),limits = c(0,2.01)) +
  scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(101)),label=c("0","1","5","10","30","50","100"),limits = c(0,2.01)) +
  coord_fixed() + ### for 1:1 ratio
  theme(axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.title=element_text(size=13, face="bold", hjust = 0.5),  ###### hjust 
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.title.align = 0.5,
        legend.position = "none",
        text = element_text(family = "sans"),
        panel.grid = element_line(size = 0.1)) + ###### panel.grid
  ggtitle("MF Single") 
#MF_s_mx_TPplot
pdf("output/3a_MF_s_TP_whole_INDEL.pdf",width = 4, height = 4)
print(MF_s_mx_TPplot)
dev.off()
#===============MT_s_mx_TP_sensitivity==============#
MT_s_mx_TP_df <- read.table("4.MT_tp_TP_sensitivity_indel.txt", header = TRUE)
MT_s_mx_TP_df <- separate(data=MT_s_mx_TP_df, col= case.control, sep=",", into = c("case","control"))
MT_s_mx_TP_df$case <- as.numeric(MT_s_mx_TP_df$case)
MT_s_mx_TP_df$control <- as.numeric(MT_s_mx_TP_df$control)
MT_s_mx_TP_df$case <- log10(((MT_s_mx_TP_df$case*100)+1))
MT_s_mx_TP_df$control <- log10(((MT_s_mx_TP_df$control*100)+1))
######################################################################################################################
MT_s_mx_TP_somatic_df <- read.table("4.MT_tp_TP_somatic_sensitivity_indel.txt", header = TRUE)
MT_s_mx_TP_somatic_df <- separate(data=MT_s_mx_TP_somatic_df, col= case.control, sep=",", into = c("case","control"))
MT_s_mx_TP_somatic_df$case <- as.numeric(MT_s_mx_TP_somatic_df$case)
MT_s_mx_TP_somatic_df$control <- as.numeric(MT_s_mx_TP_somatic_df$control)
MT_s_mx_TP_somatic_df$case <- log10(((MT_s_mx_TP_somatic_df$case*100)+1))
MT_s_mx_TP_somatic_df$control <- log10(((MT_s_mx_TP_somatic_df$control*100)+1))
######################################################################################################################
MT_s_mx_TP_all_df <- bind_rows(MT_s_mx_TP_df,MT_s_mx_TP_somatic_df)
######################################################################################################################
MT_s_mx_TPplot <- ggplot() +
  geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_point(data = MT_s_mx_TP_all_df, aes(case, control, fill = sensitivity),size=5,shape=21,color="black",stroke = 0.5) +
  scale_fill_gradientn(colors=c("white","#FDE725FF","#B8DE29FF","#73D055FF","#55C667FF","#29AF7FFF","#1F968BFF","#238A8DFF","#2D708EFF","#39568CFF","#404788FF","#482677FF","#440154FF"),values = c(0.0,0.5,1.0), breaks=c(0.25,0.50,0.75), limits=c(0,1)) +
  theme_bw() +#### white background 
  xlab("case VAF (%)") + ylab("control VAF (%)") +
  scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(101)),label=c("0","1","5","10","30","50","100"),limits = c(0,2.01)) +
  scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(101)),label=c("0","1","5","10","30","50","100"),limits = c(0,2.01)) +
  coord_fixed() + ### for 1:1 ratio
  theme(axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.title=element_text(size=13, face="bold", hjust = 0.5),  ###### hjust 
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.title.align = 0.5,
        legend.position = "none",
        text = element_text(family = "sans"),
        panel.grid = element_line(size = 0.1)) + ###### panel.grid
  ggtitle("MT Single") 
#MT_s_mx_TPplot
pdf("output/3a_MT_s_TP_whole_INDEL.pdf",width = 4, height = 4)
print(MT_s_mx_TPplot)
dev.off()
#===============MT_p_mx_TP_sensitivity==============#
MT_p_mx_TP_df <- read.table("5.MT_P_tp_TP_sensitivity_indel.txt", header = TRUE)
MT_p_mx_TP_df <- separate(data=MT_p_mx_TP_df, col= case.control, sep=",", into = c("case","control"))
MT_p_mx_TP_df$case <- as.numeric(MT_p_mx_TP_df$case)
MT_p_mx_TP_df$control <- as.numeric(MT_p_mx_TP_df$control)
MT_p_mx_TP_df$case <- log10(((MT_p_mx_TP_df$case*100)+1))
MT_p_mx_TP_df$control <- log10(((MT_p_mx_TP_df$control*100)+1))
######################################################################################################################
MT_p_mx_TPplot <- ggplot() +
  geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_point(data = MT_p_mx_TP_df, aes(case, control, fill = sensitivity),size=5,shape=21,color="black",stroke = 0.5) +
  scale_fill_gradientn(colors=c("white","#FDE725FF","#B8DE29FF","#73D055FF","#55C667FF","#29AF7FFF","#1F968BFF","#238A8DFF","#2D708EFF","#39568CFF","#404788FF","#482677FF","#440154FF"),values = c(0.0,0.5,1.0), breaks=c(0.25,0.50,0.75), limits=c(0,1)) +
  theme_bw() +#### white background 
  xlab("case VAF (%)") + ylab("control VAF (%)") +
  scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(101)),label=c("0","1","5","10","30","50","100"),limits = c(0,2.01)) +
  scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(101)),label=c("0","1","5","10","30","50","100"),limits = c(0,2.01)) +
  coord_fixed() + ### for 1:1 ratio
  theme(axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.title=element_text(size=13, face="bold", hjust = 0.5),  ###### hjust 
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.title.align = 0.5,
        legend.position = "none",
        text = element_text(family = "sans"),
        panel.grid = element_line(size = 0.1)) + ###### panel.grid
  ggtitle("MT Paired") 
# MT_p_mx_TPplot
pdf("output/3a_MT_p_TP_whole_INDEL.pdf",width = 4, height = 4)
print(MT_p_mx_TPplot)
dev.off()
#===============HC20_s_mx_TP_sensitivity==============#
HC20_s_mx_TP_df <- read.table("7.HC20_tp_TP_sensitivity_indel.txt", header = TRUE)
HC20_s_mx_TP_df <- separate(data=HC20_s_mx_TP_df, col= case.control, sep=",", into = c("case","control"))
HC20_s_mx_TP_df$case <- as.numeric(HC20_s_mx_TP_df$case)
HC20_s_mx_TP_df$control <- as.numeric(HC20_s_mx_TP_df$control)
HC20_s_mx_TP_df$case <- log10(((HC20_s_mx_TP_df$case*100)+1))
HC20_s_mx_TP_df$control <- log10(((HC20_s_mx_TP_df$control*100)+1))
######################################################################################################################
HC20_s_mx_TP_somatic_df <- read.table("7.HC20_tp_TP_somatic_sensitivity_indel.txt", header = TRUE)
HC20_s_mx_TP_somatic_df <- separate(data=HC20_s_mx_TP_somatic_df, col= case.control, sep=",", into = c("case","control"))
HC20_s_mx_TP_somatic_df$case <- as.numeric(HC20_s_mx_TP_somatic_df$case)
HC20_s_mx_TP_somatic_df$control <- as.numeric(HC20_s_mx_TP_somatic_df$control)
HC20_s_mx_TP_somatic_df$case <- log10(((HC20_s_mx_TP_somatic_df$case*100)+1))
HC20_s_mx_TP_somatic_df$control <- log10(((HC20_s_mx_TP_somatic_df$control*100)+1))
######################################################################################################################
HC20_s_mx_TP_all_df <- bind_rows(HC20_s_mx_TP_df,HC20_s_mx_TP_somatic_df)
######################################################################################################################
HC20_s_mx_TPplot <- ggplot() +
  geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_point(data = HC20_s_mx_TP_all_df, aes(case, control, fill = sensitivity),size=5,shape=21,color="black",stroke = 0.5) +
  scale_fill_gradientn(colors=c("white","#FDE725FF","#B8DE29FF","#73D055FF","#55C667FF","#29AF7FFF","#1F968BFF","#238A8DFF","#2D708EFF","#39568CFF","#404788FF","#482677FF","#440154FF"),values = c(0.0,0.5,1.0), breaks=c(0.25,0.50,0.75), limits=c(0,1)) +
  theme_bw() +#### white background
  xlab("case VAF (%)") + ylab("control VAF (%)") +
  scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(101)),label=c("0","1","5","10","30","50","100"),limits = c(0,2.01)) +
  scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(101)),label=c("0","1","5","10","30","50","100"),limits = c(0,2.01)) +
  coord_fixed() + ### for 1:1 ratio
  theme(axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.title=element_text(size=13, face="bold", hjust = 0.5),  ###### hjust 
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.title.align = 0.5,
        legend.position = "none",
        text = element_text(family = "sans"),
        panel.grid = element_line(size = 0.1)) + ###### panel.grid
  ggtitle("HC p.20")
pdf("output/3a_HC20_s_TP_whole_INDEL.pdf",width = 4, height = 4)
print(HC20_s_mx_TPplot)
dev.off()

#===============HC200_s_mx_TP_sensitivity==============#
HC200_s_mx_TP_df <- read.table("12.HC200_tp_TP_sensitivity_indel.txt", header = TRUE)
HC200_s_mx_TP_df <- separate(data=HC200_s_mx_TP_df, col= case.control, sep=",", into = c("case","control"))
HC200_s_mx_TP_df$case <- as.numeric(HC200_s_mx_TP_df$case)
HC200_s_mx_TP_df$control <- as.numeric(HC200_s_mx_TP_df$control)
HC200_s_mx_TP_df$case <- log10(((HC200_s_mx_TP_df$case*100)+1))
HC200_s_mx_TP_df$control <- log10(((HC200_s_mx_TP_df$control*100)+1))
######################################################################################################################
HC200_s_mx_TP_somatic_df <- read.table("12.HC200_tp_TP_somatic_sensitivity_indel.txt", header = TRUE)
HC200_s_mx_TP_somatic_df <- separate(data=HC200_s_mx_TP_somatic_df, col= case.control, sep=",", into = c("case","control"))
HC200_s_mx_TP_somatic_df$case <- as.numeric(HC200_s_mx_TP_somatic_df$case)
HC200_s_mx_TP_somatic_df$control <- as.numeric(HC200_s_mx_TP_somatic_df$control)
HC200_s_mx_TP_somatic_df$case <- log10(((HC200_s_mx_TP_somatic_df$case*100)+1))
HC200_s_mx_TP_somatic_df$control <- log10(((HC200_s_mx_TP_somatic_df$control*100)+1))
######################################################################################################################
HC200_s_mx_TP_all_df <- bind_rows(HC200_s_mx_TP_df,HC200_s_mx_TP_somatic_df)
######################################################################################################################
HC200_s_mx_TPplot <- ggplot() +
  geom_hline(yintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_vline(xintercept = log10(10+1), color = 'black', lty = 'dashed') +
  geom_point(data = HC200_s_mx_TP_all_df, aes(case, control, fill = sensitivity),size=5,shape=21,color="black",stroke = 0.5) +
  scale_fill_gradientn(colors=c("white","#FDE725FF","#B8DE29FF","#73D055FF","#55C667FF","#29AF7FFF","#1F968BFF","#238A8DFF","#2D708EFF","#39568CFF","#404788FF","#482677FF","#440154FF"),values = c(0.0,0.5,1.0), breaks=c(0.25,0.50,0.75), limits=c(0,1)) +
  theme_bw() +#### white background
  xlab("case VAF (%)") + ylab("control VAF (%)") +
  scale_x_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(101)),label=c("0","1","5","10","30","50","100"),limits = c(0,2.01)) +
  scale_y_continuous(breaks = c(0,log10(2),log10(6),log10(11),log10(31),log10(51),log10(101)),label=c("0","1","5","10","30","50","100"),limits = c(0,2.01)) +
  coord_fixed() + ### for 1:1 ratio
  theme(axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.title=element_text(size=13, face="bold", hjust = 0.5),  ###### hjust 
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.title.align = 0.5,
        legend.position = "none",
        text = element_text(family = "sans"),
        panel.grid = element_line(size = 0.1)) + ###### panel.grid
  ggtitle("HC p.200")
pdf("output/3a_HC200_s_TP_whole_INDEL.pdf",width = 4, height = 4)
print(HC200_s_mx_TPplot)
dev.off()





















