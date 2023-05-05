library(ggplot2)
library(cowplot)
library(ggpubr)

#######
DP = ""


data_f <- read.csv(paste("sample_specific_Perf_by_VAF.hc.snv.",DP,"auprc.txt",sep=""), sep ='\t', header=F)
df_upper = read.delim(paste("FN_CP_snv_paired_samplespecific.",DP,"txt", sep =""), header = F)
df_upper$max = 1
df_upper$hmean = 1/rowMeans(1/df_upper[,c(4,5)])
df_upper

data_f

scale_lable = c(expression(bold('< 1%')),expression(bold('< 4%')),expression(bold('< 10%')),expression(bold('< 15%')),expression(bold('< 25%')),expression(bold("">="25%")))
data = data_f
data$V1 <- factor(data$V1, levels = c("1.MH", "3.MF","14.DM", "4.MT", "17.MT_PD", "16.STK","7.HC20", "12.HC200",  "13.MSM"))
data
pre<-  ggplot(data, aes(x = data$V11, y= data$V9, group = data$V1)) +
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2,size = 0.3 ) + 
  geom_vline(xintercept = 10, alpha = 0.4,linetype =2, size = 0.3 ) + 
  geom_line(aes(color=data$V1 ), size = 0.3) + 
  geom_point(aes(color=data$V1, shape = data$V1),  size = 1 ) +
  scale_shape_manual(values=c(17, 17, 17, 15, 15, 15, 19, 19, 13))+
  scale_x_continuous(breaks = c(1, 4, 10, 15, 25, 32),label=scale_lable) +
  theme_bw() +
  scale_colour_manual(values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#33A6A6", "#035AA6", "#A0A603", "#025959", "#F20587"))+
  coord_cartesian( ylim = c(0:1.2)) + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) + 
  labs(title="Precision")
pre

fscore <- ggplot() +
  geom_line(data=df_upper, aes(x=V1, y = hmean),linetype = "twodash", color = "black",size = 0.3) + 
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2,size = 0.3 ) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2,size = 0.3 ) + 
  geom_line(data = data, aes(x = data$V11,  y= as.numeric(as.character(data$V10)), group = data$V1, color=data$V1 ), size = 0.3) + 
  geom_point(data = data, aes(x = data$V11,  y= as.numeric(as.character(data$V10)), group = data$V1, color=data$V1, shape = data$V1),  size = 1 ) +
  scale_shape_manual(values=c(17, 17, 17, 15, 15, 15, 19, 19, 13))+
  scale_x_continuous(breaks = c(1, 4, 10, 15, 25, 32),label=scale_lable) +
  theme_bw() +
  scale_colour_manual(values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#33A6A6", "#035AA6", "#A0A603", "#025959", "#F20587"))+
  coord_cartesian( ylim = c(0:1.2)) + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) +  
  labs(title="F1-score")
fscore

auprc <- ggplot(data, aes(x = data$V11,  y= as.numeric(as.character(data$V12)), group = data$V1)) +
  geom_vline(xintercept = 5, alpha = 0.4,linetype =2,size = 0.3 ) + 
  geom_vline(xintercept = 10, alpha = 0.4,linetype =2, size = 0.3 ) + 
  geom_line(aes(color=data$V1 ), size = 0.3) + 
  geom_point(aes(color=data$V1, shape = data$V1),  size = 1 ) +
  scale_shape_manual(values=c(17, 17, 17, 15, 15, 15, 19, 19, 13))+
  scale_x_continuous(breaks = c(1, 4, 10, 15, 25, 32),label=scale_lable) +
  theme_bw() +
  scale_colour_manual(values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#33A6A6", "#035AA6", "#A0A603", "#025959", "#F20587"))+
  coord_cartesian( ylim = c(0:1.2)) + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) + 
  labs(title="AUPRC")

auprc
data
sen <- ggplot() +
  geom_line(data=df_upper, aes(x=V1, y = V4),linetype = "twodash", color = "black",size = 0.3) + 
  geom_vline(xintercept = 5, alpha = 0.4, size = 0.3 ,linetype =2) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2, size = 0.3 ) + 
  geom_line(data = data,aes(x = data$V11, y= data$V6, group = data$V1, color=data$V1 ), size = 0.3) + 
  geom_point(data = data,aes(x = data$V11, y= data$V6, group = data$V1, color=data$V1, shape = data$V1),  size = 1 ) +
  scale_shape_manual(values=c(17, 17, 17, 15, 15, 15, 19, 19, 13))+
  scale_x_continuous(breaks = c(1,4, 10, 15, 25, 32),label=scale_lable) +
  theme_bw() +
  scale_colour_manual(values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#33A6A6", "#035AA6", "#A0A603", "#025959", "#F20587"))+
  coord_cartesian( ylim = c(0:1.2)) + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) + 
  labs(title="Sensitivity")
sen
#data#FP/1Mbp
nc.refhom = 33093574 
nc.germline.snv = 17824
nc.germline.ind = 327
nc_pos_snv = nc.refhom + nc.germline.snv
nc_pos_ind = nc.refhom + nc.germline.ind

FP <- ggplot(data, aes(x = data$V11, y= log10((data$V5*1000000)/(39*nc_pos_snv) +1 ), group = data$V1)) +
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2, size = 0.3) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2, size = 0.3 ) + 
  geom_line(aes(color=data$V1 ), size = 0.3) + 
  geom_point(aes(color=data$V1, shape = data$V1),  size = 1 ) +
  scale_x_continuous(breaks = c(1, 4, 10, 15, 25, 32),label=scale_lable) +
  scale_y_continuous(breaks = c(1, 2,3,4,5,6),trans='sqrt') +
  scale_shape_manual(values=c(17, 17, 17, 15, 15, 15, 19, 19, 13))+
  theme_bw() +
  coord_cartesian( ylim = c(0,3)) +
  #scale_y_continuous(trans='sqrt') + 
  scale_colour_manual(values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#33A6A6", "#035AA6", "#A0A603", "#025959", "#F20587"))+
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) + 
  labs(title="log10(FP/1Mbp)", y = "")
FP

sen
pre
fscore
auprc
ggarrange(sen, pre,  fscore,auprc,FP, 
          ncol = 5,nrow = 1,
          common.legend = TRUE )
ggsave(file = paste0("SS_perf.SNV.",DP,'.pdf'), width = 10, height = 3)

##INDEL
#######

#vaf10 for D4

data_f <- read.csv(paste("sample_specific_Perf_by_VAF.hc.ind.",DP,"auprc.txt",sep=""), sep ='\t', header=F)
df_upper = read.delim(paste("FN_CP_snv_paired_samplespecific.ind.",DP,"txt", sep =""), header = F)
df_upper$max = 1
df_upper$hmean = 1/rowMeans(1/df_upper[,c(4,5)])
df_upper

data_f
#data_f$V11[data_f$V11 == 12] <-16
#data <- subset(data_f, data$V6 != 0)
scale_lable = c(expression(bold('< 1%')),expression(bold('< 4%')),expression(bold('< 10%')),expression(bold('< 15%')),expression(bold('< 25%')),expression(bold("">="25%")))
data = data_f
data$V1 <- factor(data$V1, levels = c("3.MF", "4.MT", "17.MT_PD", "16.STK","7.HC20", "12.HC200", "13.MSM"))
data
pre<-  ggplot(data, aes(x = data$V11, y= data$V9, group = data$V1)) +
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2,size = 0.3 ) + 
  geom_vline(xintercept = 10, alpha = 0.4,linetype =2, size = 0.3 ) + 
  geom_line(aes(color=data$V1 ), size = 0.3) + 
  geom_point(aes(color=data$V1, shape = data$V1),  size = 1 ) +
  scale_shape_manual(values=c(17, 15, 15, 15, 19, 19,13))+
  scale_colour_manual(values = c("#F2780C",  "#491F73","#33A6A6", "#035AA6", "#A0A603", "#025959","#F20587"))+
  scale_x_continuous(breaks = c(1, 4, 10, 15, 25, 32),label=scale_lable) +
  theme_bw() +
  coord_cartesian( ylim = c(0:1.2)) + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) + 
  labs(title="Precision")
pre

fscore <- ggplot() +
  geom_line(data=df_upper, aes(x=V1, y = hmean),linetype = "twodash", color = "black",size = 0.3) + 
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2,size = 0.3 ) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2,size = 0.3 ) + 
  geom_line(data = data, aes(x = data$V11,  y= as.numeric(as.character(data$V10)), group = data$V1, color=data$V1 ), size = 0.3) + 
  geom_point(data = data, aes(x = data$V11,  y= as.numeric(as.character(data$V10)), group = data$V1, color=data$V1, shape = data$V1),  size = 1 ) +
  scale_shape_manual(values=c(17, 15, 15, 15, 19, 19,13))+
  scale_colour_manual(values = c("#F2780C",  "#491F73","#33A6A6", "#035AA6", "#A0A603", "#025959","#F20587"))+
  scale_x_continuous(breaks = c(1, 4, 10, 15, 25, 32),label=scale_lable) +
  theme_bw() +
  coord_cartesian( ylim = c(0:1.2)) + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) +  
  labs(title="F1-score")
fscore

auprc <- ggplot(data, aes(x = data$V11,  y= as.numeric(as.character(data$V12)), group = data$V1)) +
  geom_vline(xintercept = 5, alpha = 0.4,linetype =2,size = 0.3 ) + 
  geom_vline(xintercept = 10, alpha = 0.4,linetype =2, size = 0.3 ) + 
  geom_line(aes(color=data$V1 ), size = 0.3) + 
  geom_point(aes(color=data$V1, shape = data$V1),  size = 1 ) +
  scale_x_continuous(breaks = c(1, 4, 10, 15, 25, 32),label=scale_lable) +
  theme_bw() +
  scale_shape_manual(values=c(17, 15, 15, 15, 19, 19,13))+
  scale_colour_manual(values = c("#F2780C",  "#491F73","#33A6A6", "#035AA6", "#A0A603", "#025959","#F20587"))+
  coord_cartesian( ylim = c(0:1.2)) + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) + 
  labs(title="AUPRC")

auprc
data
sen <- ggplot() +
  geom_line(data=df_upper, aes(x=V1, y = V4),linetype = "twodash", color = "black",size = 0.3) + 
  geom_vline(xintercept = 5, alpha = 0.4, size = 0.3 ,linetype =2) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2, size = 0.3 ) + 
  geom_line(data = data,aes(x = data$V11, y= data$V6, group = data$V1, color=data$V1 ), size = 0.3) + 
  geom_point(data = data,aes(x = data$V11, y= data$V6, group = data$V1, color=data$V1, shape = data$V1),  size = 1 ) +
  scale_shape_manual(values=c(17, 15, 15, 15, 19, 19,13))+
  scale_colour_manual(values = c("#F2780C",  "#491F73","#33A6A6", "#035AA6", "#A0A603", "#025959","#F20587"))+
  scale_x_continuous(breaks = c(1,4, 10, 15, 25, 32),label=scale_lable) +
  theme_bw() +
  coord_cartesian( ylim = c(0:1.2)) + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) + 
  labs(title="Sensitivity")
sen
#data#FP/1Mbp
nc.refhom = 33093574 
nc.germline.snv = 17824
nc.germline.ind = 327
nc_pos_snv = nc.refhom + nc.germline.snv
nc_pos_ind = nc.refhom + nc.germline.ind

FP <- ggplot(data, aes(x = data$V11, y= log10((data$V5*1000000)/(39*nc_pos_snv) +1 ), group = data$V1)) +
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2, size = 0.3) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2, size = 0.3 ) + 
  geom_line(aes(color=data$V1 ), size = 0.3) + 
  geom_point(aes(color=data$V1, shape = data$V1),  size = 1 ) +
  scale_x_continuous(breaks = c(1, 4, 10, 15, 25, 32),label=scale_lable) +
  scale_y_continuous(breaks = c(1, 2,3,4,5,6),trans='sqrt') +
  scale_shape_manual(values=c(17, 15, 15, 15, 19, 19,13))+
  scale_colour_manual(values = c("#F2780C",  "#491F73","#33A6A6", "#035AA6", "#A0A603", "#025959","#F20587"))+
  theme_bw() +
  coord_cartesian( ylim = c(0,2)) +
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) + 
  labs(title="log10(FP/1Mbp)", y = "")
FP

sen
pre
fscore
auprc
ggarrange(sen, pre,  fscore,auprc,FP, 
          ncol = 5,nrow = 1,
          common.legend = TRUE )
ggsave(file = paste0("SS_perf.IND.",DP,'.pdf'), width = 10, height = 3)


