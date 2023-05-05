# Library
library(ggplot2)
library("munsell")
library("colorspace")
library(dplyr)
library(ggpubr)


#True positives
tp = read.csv("/Users/tinkertwerk/Desktop/Results/Figures/Figure2/jaccard/D4.TP.tp.jcd.txt",sep = '\t',header=FALSE)
tp
tp$V1 <- factor(tp$V1, levels=c( 'MH_d4', 'MF_d4', 'DM_d4', 'MT_d4', 'HC20_d4','HC200_d4'))
tp$V2 <- factor(tp$V2, levels=c('HC200_d4','HC20_d4', 'MT_d4', 'DM_d4','MF_d4', 'MH_d4'))
D4 <- tp %>%
  arrange(V2) %>%
  group_by(V1) %>%
  filter(row_number() <= which(V1 == V2)) %>%
  ggplot(aes(V1, V2, fill=V3)) + 
  geom_tile() + 
  scale_fill_gradientn( limits = c(0,1) ,colours = c('white',  '#354F79' ,'#1D1B5C')) +
  theme_classic()+
  theme(aspect.ratio=1,
        axis.text.x = element_text(size = rel(1), angle = -45,vjust=0.5),
        panel.grid = element_blank(), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  labs(title="True positives")



#Germline false positives
tp = read.csv("/Users/tinkertwerk/Desktop/Results/Figures/Figure2/jaccard/D4.FP.tp.jcd.txt",sep = '\t',header=FALSE)
tp
tp$V1 <- factor(tp$V1, levels=c( 'MH_d4', 'MF_d4', 'DM_d4', 'MT_d4', 'HC20_d4','HC200_d4'))
tp$V2 <- factor(tp$V2, levels=c('HC200_d4','HC20_d4', 'MT_d4', 'DM_d4','MF_d4', 'MH_d4'))
D4 <-tp %>%
  arrange(V2) %>%
  group_by(V1) %>%
  filter(row_number() <= which(V1 == V2)) %>%
  ggplot(aes(V1, V2, fill=V3)) + 
  geom_tile() + 
  scale_fill_gradientn( limits = c(0,1) ,colours = c('white',  '#9C0C02' ,'#780901')) +
  theme_classic()+
  theme(aspect.ratio=1,
        axis.text.x = element_text(size = rel(1), angle = -45,vjust=0.5),
        panel.grid = element_blank(), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  labs(title="Germline false positives")
 

#Nonvariant false positives
tp = read.csv("/Users/tinkertwerk/Desktop/Results/Figures/Figure2/jaccard/D4.FP.mx.jcd.txt",sep = '\t',header=FALSE)
tp
tp$V1 <- factor(tp$V1, levels=c( 'MH_d4', 'MF_d4', 'DM_d4', 'MT_d4', 'HC20_d4','HC200_d4'))
tp$V2 <- factor(tp$V2, levels=c('HC200_d4','HC20_d4', 'MT_d4', 'DM_d4','MF_d4', 'MH_d4'))
D4 <-tp %>%
  arrange(V2) %>%
  group_by(V1) %>%
  filter(row_number() <= which(V1 == V2)) %>%
  ggplot(aes(V1, V2, fill=V3)) + 
  geom_tile() + 
  scale_fill_gradientn( limits = c(0,1) ,colours = c('white',  '#9C0C02' ,'#780901')) +
  theme_classic()+
  theme(aspect.ratio=1,
        axis.text.x = element_text(size = rel(1), angle = -45,vjust=0.5),
        panel.grid = element_blank(), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  labs(title="Nonvariant false positives")


