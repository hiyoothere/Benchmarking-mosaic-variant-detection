library(ggplot2)


data = read.csv("/Users/tinkertwerk/Desktop/Results/Figures/Figure4/feature/features.total.txt",sep = '\t',header=TRUE)
data <- data.frame(data)
data
data$category <- factor(data$category, levels = c("Genotype level feature", "Sequencing level feature","Alignment level feature"))

data$VAR <- factor(data$VAR, levels = c("SNV", "INDEL"))
data
p <- ggplot(data, aes(x= data$category, y= AUC, color=data$VAR)) + 
  geom_boxplot(outlier.shape=NA) + 
  geom_point(position= position_jitterdodge(), alpha = 0.5, size = 3) + 
  theme_bw() + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(size = rel(1.5), angle = -45,vjust=0.5),
        axis.text.y = element_text(size = rel(1.5),vjust=0.5),
        panel.background = element_blank()) 

p


GL <- subset(data, category== 'Genotype level feature')
GL
AL <- subset(data, category== 'Alignment level feature')

SL <- subset(data, category== 'Sequencing level feature')
SL

#average 
AUC_GL <- GL$AUC
mean(AUC_GL) #0.7685675
median(AUC_GL) #0.8076027

AUC_AL <- AL$AUC
mean(AUC_AL) #0.5899941
median(AUC_AL) #0.5554759

AUC_SL <- SL$AUC
mean(AUC_SL) #0.5938106
median(AUC_SL) #0.5797379


#Compare GL vs AL
wilcox.test(AUC_GL, AUC_AL) #W = 1954, p-value = 2.412e-06
wilcox.test(AUC_GL, AUC_SL) #W = 2001, p-value = 3.702e-06
