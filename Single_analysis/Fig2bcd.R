library(ggplot2)
library(cowplot)
library(ggpubr)

#####For Fig. 2b-2c)#####

DP = ""      
data_f <- read.csv(paste("single_Perf_by_VAF.hc.snv.", DP, "auprc.txt",sep=""),header=FALSE,sep='\t')
df_upper = read.delim(paste("FN_CP_snv.",DP,"txt", sep =""), header = F)
df_upper$max = 1
df_upper$hmean = 1/rowMeans(1/df_upper[,c(4,5)]) #Upper limit for F1-score 
df_upper


data <- subset(data_f, data$V6 != 0)
scale_lable = c(expression(bold('< 1%')),expression(bold('< 3%')),expression(bold('< 7.5%')),expression(bold('< 9.6%')),expression(bold('< 25%')),expression(bold("">="25%")))
data
data <- data_f
data$V1 <- factor(data$V1, levels = c("1.MH", "3.MF","14.DM", "4.MT", "7.HC20", "12.HC200"))
pre <- ggplot(data, aes(x = data$V11, y= data$V9, group = data$V1)) +
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2, size = 0.3) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2, size = 0.3 ) + 
  geom_line(aes(color=data$V1 ), size = 0.3) + 
  geom_point(aes(color=data$V1, shape = data$V1),  size = 2 ) +
  scale_x_continuous(breaks = c(1, 3, 7.5, 9.6, 20, 35),label=scale_lable) +
  theme_bw() +
  scale_colour_manual(name = 'Detection Stragtegy', values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#A0A603", "#025959"))+
  scale_shape_manual(name = 'Detection Stragtegy', values = c(19, 19, 19, 17, 15, 15)) +
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

f1score <- ggplot() +
  geom_line(data=df_upper, aes(x=V1, y = hmean),linetype = "twodash", color = "black",size = 0.3) + 
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2, size = 0.3) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2, size = 0.3 ) + 
  geom_line(data = data, aes(x = data$V11, y= as.numeric(data$V10), color=data$V1, group = data$V1), size = 0.3) + 
  geom_point(data = data, aes(x = data$V11, y= as.numeric(data$V10), color=data$V1, group = data$V1, shape = data$V1),  size = 2 ) +
  scale_x_continuous(breaks = c(1, 3, 7.5, 9.6, 20, 35),label=scale_lable) +
  theme_bw() +
  scale_colour_manual(name = 'Detection Stragtegy', values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#A0A603", "#025959"))+
  scale_shape_manual(name = 'Detection Stragtegy', values = c(19, 19, 19, 17, 15, 15)) +
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
f1score
auprc <- ggplot(data, aes(x = data$V11, y= as.numeric(as.character(data$V12)), group = data$V1)) +
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2, size = 0.3) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2, size = 0.3 ) + 
  geom_line(aes(color=data$V1 ), size = 0.3) + 
  geom_point(aes(color=data$V1, shape = data$V1),  size = 2 ) +
  scale_x_continuous(breaks = c(1, 3, 7.5, 9.6, 20, 35),label=scale_lable) +
  theme_bw() +
  scale_colour_manual(name = 'Detection Stragtegy', values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#A0A603", "#025959"))+
  scale_shape_manual(name = 'Detection Stragtegy', values = c(19, 19, 19, 17, 15, 15)) +
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

data$V1
sen <- ggplot() +
  geom_line(data=df_upper, aes(x=V1, y = V4),linetype = "twodash", color = "black",size = 0.3) + 
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2, size = 0.3) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2, size = 0.3 ) + 
  geom_line(data =data, aes(x = data$V11, y= data$V6, color=data$V1 ), size = 0.3) + 
  geom_point(data =data, aes(x = data$V11, y= data$V6,color=data$V1, shape = data$V1,group = data$V1),  size = 2 ) +
  scale_x_continuous(breaks = c(1, 3, 7.5, 9.6, 20, 35),label=scale_lable) +
  theme_bw() +
  scale_colour_manual(name = 'Detection Stragtegy', values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#A0A603", "#025959"))+
  scale_shape_manual(name = 'Detection Stragtegy', values = c(19, 19, 19, 17, 15, 15)) +
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

# FP/1Mbp
nc.refhom = 33093574 
nc.germline.snv = 17824
nc.germline.ind = 327
nc_pos_snv = nc.refhom + nc.germline.snv
nc_pos_ind = nc.refhom + nc.germline.ind
nc_pos_snv
data$FP_rate = log10(((data$V5)*1000000)/(nc_pos_snv*39) +1 )
#write.table(data,paste("single_Perf_by_VAF.hc.snv.", DP, "auprc.FP.txt",sep=""), sep = '\t',quote = F, col.names = F, row.names = F)
                     
FP <- ggplot(data, aes(x = data$V11, y= log10((data$V5*1000000)/(nc_pos_snv*39) + 1), group = data$V1)) +
  geom_vline(xintercept = 5, alpha = 0.4, linetype =2, size = 0.3) + 
  geom_vline(xintercept = 10, alpha = 0.4, linetype =2, size = 0.3 ) + 
  geom_line(aes(color=data$V1 ), size = 0.3) + 
  geom_point(aes(color=data$V1, shape = data$V1),  size = 2 ) +
  scale_x_continuous(breaks = c(1, 3, 7.5, 9.6, 20, 35),label=scale_lable) +
  scale_y_continuous(breaks = c(1, 2,3,4,5,6),trans='sqrt') +
  theme_bw() +
  #scale_y_continuous(trans='sqrt') + 
  scale_colour_manual(name = 'Detection Stragtegy', values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#A0A603", "#025959"))+
  scale_shape_manual(name = 'Detection Stragtegy', values = c(19, 19, 19, 17, 15, 15)) +
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(face = 'bold', size = 7.4, angle = -70, vjust = 0, hjust = 0 ),
        axis.text.y = element_text(face = 'bold', color = 'black',size = 7.4),
        axis.title.x = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(face = 'bold', size = 11, hjust = 0.5),
        legend.title = element_text(face = 'bold', size = 9)) + 
  labs(title="FP/1Mbp", y = "")


ggarrange(sen, pre,  f1score,auprc, FP,
          ncol = 5,nrow = 1,
          common.legend = TRUE )
ggsave(file = paste0("Single_perf.",DP,'.pdf'), width = 10, height = 3)

##### Precision Sensitivirt ratio plot (Fig. 2d) #####
df_ratio=  data.frame(data_f)
df_ratio$LR <- log2(as.numeric(data_f$V9)/as.numeric(data_f$V6))
newcol <- c('V1',"V2",'LR')
df_ratio <- df_ratio[newcol]
colnames(df_ratio) <- c("Tool", "range", "LRatio")
head(df_ratio)

df_ratio

df_stat = data.frame()
for (i in 1:6){
  tmp_tool = l_tool[i]
  print (tmp_tool)
  df_tool <- data_f[grep(tmp_tool,data_f$V1),]
  print (tmp_tool)
  df_tool$LR <- log2(as.numeric(df_tool$V9)/as.numeric(df_tool$V6))
  sample.n <- length(df_tool$LR)
  sample.sd <- sd(df_tool$LR,na.rm = T)
  sample.mean <- mean(df_tool$LR,na.rm = T)
  sample.se <- sample.sd/sqrt(sample.n)
  alpha = 0.05
  degrees.freedom = sample.n - 1
  t.score = qt(p=alpha/2, df=degrees.freedom,lower.tail=F)
  print(t.score)
  margin.error <- t.score * sample.se
  lower.bound <- sample.mean - margin.error
  upper.bound <- sample.mean + margin.error
  print(c(lower.bound,upper.bound))
  print(sample.se)
  Median = median(df_tool$LR, na.rm = T)
  df_stat = rbind(df_stat, c(tmp_tool, Median, lower.bound, upper.bound))
}

colnames(df_stat) <- c("Tool", "median", "ymin", "ymax")
sum(as.numeric(df_stat$median))
df_stat

write.table(df_ratio,paste("Single_ratio.snv.", DP, "auprc.FP.txt",sep=""), sep = '\t',quote = F, col.names = F, row.names = F)
write.table(df_ratio,paste("Single_ratio_median.snv.", DP, "auprc.FP.txt",sep=""), sep = '\t',quote = F, col.names = F, row.names = F)

scale_lable = c('<1%', '1%–2%', '2%–3%', '3%–4%', '4%–7.5%', '7.5%–9.6%', '9.6%–25%','≥25%' )
df_ratio$Tool <- factor(df_ratio$Tool, levels = c("1.MH", "3.MF","14.DM", "4.MT", "7.HC20", "12.HC200"))
ggplot(df_ratio) + 
  geom_point(data=df_stat, aes(x=as.numeric(median), y= reorder(Tool, as.numeric(median))), size = 10, alpha = 0.4, color = "black")  + 
  geom_errorbar(data=df_stat, aes(y = Tool, xmin = as.numeric(ymin), xmax = as.numeric(ymax)),width=.2,position=position_dodge(.9)) + 
  geom_point(aes(y=Tool, x = LRatio, color = Tool, size = range )) + 
  scale_colour_manual(values = c("#BF4141","#F2780C",  "#F2AE2E", "#491F73","#A0A603", "#025959")) + 
  
  
  scale_size_discrete(labels=scale_lable) + 
  theme_bw() + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 1.4,
        legend.position = "bottom",
        
        #panel.grid.major = element_blank(),
        #panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(size = rel(1.5), angle = -45,vjust=0.5)) + 
  
  labs(title="Ratio of Precision to Sensitivity") 

