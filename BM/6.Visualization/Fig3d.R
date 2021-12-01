library(ggplot2)

#SNV
data = read.csv("/Users/tinkertwerk/Desktop/Results/Figures/Figure3/shared/2fold_sen.txt",sep = '\t',header=FALSE)
data

total <- subset(data, data$V2=='2fdown_total'  | data$V2=='2fup_total')
total
total$V1 <- factor(total$V1, levels = c("1.MH", "2.MH_P", "3.MF","14.DM", "4.MT","5.MT_P", "7.HC20", "12.HC200", "13.MSM"))
ggplot(data=total) + 
  geom_bar(aes(y=total$V6, x=total$V1, fill=total$V2), stat='identity', position = 'dodge') + 
  scale_fill_manual(values = c("#95A0AB", "#02587A"))+
  geom_text(aes(y=round(total$V6, digit=2), x=total$V1,label=round(total$V6, 2)), angle= 30,  size=3.5, hjust=-0.1, vjust=-0.1) + 
  theme(aspect.ratio=2) + 
  theme_classic()

#INDEL
data = read.csv("/Users/tinkertwerk/Desktop/Results/Figures/Figure3/shared/ind.2fold_sen.txt",sep = '\t',header=FALSE)
data

total <- subset(data, data$V2=='2fdown_total'  | data$V2=='2fup_total')
total
total$V1 <- factor(total$V1, levels = c( "3.MF", "4.MT","5.MT_P", "7.HC20", "12.HC200"))
ggplot(data=total) + 
  geom_bar(aes(y=total$V6, x=total$V1, fill=total$V2), stat='identity', position = 'dodge') + 
  scale_fill_manual(values = c("#95A0AB", "#02587A"))+
  geom_text(aes(y=round(total$V6, digit=2), x=total$V1,label=round(total$V6, 2)), angle= 30,  size=3.5, hjust=-0.1, vjust=-0.1) + 
  theme(aspect.ratio=2) + 
  theme_classic()
