### INDEL ###
data <- read.csv("/Users/tinkertwerk/Desktop/Results/Figures/Figure2/nA.single/single_Perf_by_VAF.hc.ind.txt", header=FALSE, sep='\t')
data$V1 <- factor(data$V1, levels = c('1.MH', '3.MF','14.DM', '4.MT', '7.HC20', '12.HC200'))

sen <- ggplot(data, aes(x = V11, y= V6, group = V1)) +
  geom_vline(xintercept = 5, alpha = 0.4, linetype = 2 , size = 0.3) +
  geom_vline(xintercept = 10, alpha = 0.4, linetype = 2, size = 0.3) +
  #geom_vline(xintercept = 15, alpha = 0.4, linetype =2 ) +
  geom_line(aes(color=V1 ), size = 0.3) +
  geom_point(aes(color=V1, shape = V1),  size = 2) +
  #scale_shape_manual(values=c(17, 15, 19))+
  scale_x_continuous(breaks = c(1,5,9.6,15,22),label=c('< 1%','< 5%','< 9.6%','< 16%','> 16%' )) +
  theme_bw() +
  scale_colour_manual(values = c("#F2780C",   "#491F73","#A0A603", "#025959"))+
  scale_shape_manual(values = c(19,  17, 15, 15)) +
  coord_cartesian( ylim = c(0:1.2)) +
  theme(aspect.ratio = 0.65,
        plot.title = element_text(face = 'bold', hjust = 0.5, size = 12),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_text(angle = -70, vjust = 0.3, hjust = 0.1, size = 8, face = 'bold'),
        axis.text.y = element_text(size = 8, face = 'bold'),
        axis.line = element_line(size = 0.5, colour = 'black', lineend = 'square'),
        legend.position = 'none') +
  labs(title='Sensitivity')

data <- subset(data, data$V6 != 0)

pre <-  ggplot(data, aes(x = V11, y= V9, group = V1)) +
  geom_vline(xintercept = 5, alpha = 0.4, linetype = 2, size = 0.3) +
  geom_vline(xintercept = 10, alpha = 0.4, linetype = 2, size = 0.3) +
  # geom_vline(xintercept = 15, alpha = 0.4, linetype =2 ) +
  geom_line(aes(color = V1 ), size = 0.3) +
  geom_point(aes(color = V1, shape = V1),  size = 2) +
  #scale_shape_manual(values=c(17, 15, 19))+
  scale_x_continuous(breaks = c(1,5,9.6,15,22),label=c('< 1%','< 5%','< 9.6%','< 16%','> 16%' )) +
  theme_bw() +
  scale_colour_manual(values = c("#F2780C",   "#491F73","#A0A603", "#025959"))+
  scale_shape_manual(values = c(19,  17, 15, 15)) +
  coord_cartesian( ylim = c(0:1.2)) +
  theme(aspect.ratio = 0.65,
        plot.title = element_text(face = 'bold', hjust = 0.5, size = 12),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_text(angle = -70, vjust = 0.3, hjust = 0.1, size = 8, face = 'bold'),
        axis.text.y = element_text(size = 8, face = 'bold'),
        axis.line = element_line(size = 0.5, colour = 'black', lineend = 'square'),
        legend.position = 'none') +
  labs(title='Precision')


fscore <- ggplot(data, aes(x = V11,  y= as.numeric(as.character(V10)), group = V1)) +
  geom_vline(xintercept = 5, alpha = 0.4, linetype = 2, size = 0.3) +
  geom_vline(xintercept = 10, alpha = 0.4, linetype = 2, size = 0.3) +
  #geom_vline(xintercept = 15, alpha = 0.4, linetype = 2) +
  geom_line(aes(color = V1 ), size = 0.3) +
  geom_point(aes(color = V1, shape = V1),  size = 2) +
  #scale_shape_manual(values=c(17, 15, 19))+
  scale_x_continuous(breaks = c(1,5,9.6,15,22),label=c('< 1%','< 5%','< 9.6%','< 16%','> 16%' )) +
  theme_bw() +
  scale_colour_manual(values = c("#F2780C",   "#491F73","#A0A603", "#025959"))+
  scale_shape_manual(values = c(19,  17, 15, 15)) +
  coord_cartesian( ylim = c(0:1.2)) +
  theme(aspect.ratio = 0.65,
        plot.title = element_text(face = 'bold', hjust = 0.5, size = 12),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_text(angle = -70, vjust = 0.3, hjust = 0.1, size = 8, face = 'bold'),
        axis.text.y = element_text(size = 8, face = 'bold'),
        axis.line = element_line(size = 0.5, colour = 'black', lineend = 'square'),
        legend.position = 'none') +
  labs(title='F1-score')

ggarrange(sen, pre, fscore, ncol = 3) %>%
  ggexport(filename = '/Users/tinkertwerk/Desktop/2.Benchmark/00.ForRevision/Fig/Fig2/ind.pdf')