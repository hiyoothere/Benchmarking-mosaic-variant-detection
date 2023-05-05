library("ggExtra")
library("ggplot2")
library("ggpattern")


##NEW AS LINE
F1 <- read.csv("Fil_ana.4.MTF1.txt",sep = '\t',header=FALSE) #output from 4.B.Filter_analysis.py
F1 <- subset(F1, F1$V1 != 'ori')
as.numeric(F1$V7)
p_F1 <- ggplot(F1, aes(x=reorder(F1$V1, -F1$V7), y=F1$V7, group = 1)) + 
  geom_hline(yintercept = 0, linetype = 'dashed') + 
  geom_line(size = 2) + 
  coord_cartesian(ylim = c(-0.002,0.004)) +
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.20,
        axis.title.x=element_blank(),
        axis.text.x = element_text(size = rel(1.5), angle =-45),
        panel.background = element_blank())  

p_F1

data = read.csv("Fil_ana.4.MT.log.txt",sep = '\t',header=TRUE) #log scaled F1-score for visualization
data
data <- subset(data, data$filter != 'ori')

TP <- subset(data,data$type.1== 'TP' & data$type== 'mx')
FP <- subset(data,data$type.1== 'FP')
TP
FP
p_count <- ggplot() + 
  geom_bar(data=TP, aes(x=reorder(TP$filter, -F1$V7), y= TP$count), stat='identity', fill='#2A788EFF', size = 3) + 
  geom_bar(data=FP[order(FP$type, decreasing = T),], aes(x=FP$filter, y= -FP$count, fill=FP$type), position = position_dodge(), stat='identity',size = 3) +
  scale_fill_manual(values = c("#b8627d", "#f68f46")) + 
  coord_cartesian(ylim = c(-5.5,5.5)) +
  theme_classic() + 
  theme(axis.line = element_line(colour = "black"),
        aspect.ratio = 0.7,
        axis.title.x=element_blank(),
        axis.text.x = element_text(size = rel(1.5), angle = -35),
        panel.background = element_blank())  + 
  geom_hline(yintercept=0, size = 1)


p_count


p_MT <- ggarrange( p_count,p_F1,
          ncol = 1,nrow = 2,
          common.legend = TRUE )


