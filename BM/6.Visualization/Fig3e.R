library(ggplot2)
RColorBrewer::brewer.pal.info


#MH-ts
data = read.csv("/Users/tinkertwerk/Desktop/Results/Figures/Figure3/shared/3grade_f.txt",sep = '\t',header=FALSE)
MH <- subset(data, data$V1== '1.MH')
MH
p_MH <- ggplot(MH,aes(x = MH$V2, y= MH$V3) ) + 
  geom_tile(data = subset(MH,  !is.null(MH$V11)), aes(fill= MH$V11) ) +
  theme_classic() + 
  ylim(c(-0.5,3.5)) + 
  geom_text(data=MH, aes(MH$V2, MH$V3, label = round(MH$V11,2))) + 
  theme(aspect.ratio=1) + 
  scale_fill_gradient(low = "#EDF0E6",
                      high = "#103D55",
                      guide = "colorbar",limits=c(0,1)) + 
  labs(title="MH-ts")
p_MH

#MH-p
MHP <- subset(data, data$V1== '2.MH_P')
MHP
p_MHP <- ggplot(MHP,aes(x = MHP$V2, y= MHP$V3) ) + 
  geom_tile(data = subset(MHP,  !is.null(MHP$V11)), aes(fill= MHP$V11) ) +
  theme_classic() + 
  ylim(c(-0.5,3.5)) + 
  geom_text(data=MHP, aes(MHP$V2, MHP$V3, label = round(MHP$V11,2))) + 
  theme(aspect.ratio=1) + 
  scale_fill_gradient(low = "#EDF0E6",
                      high = "#103D55",
                      guide = "colorbar",limits=c(0,1)) + 
  labs(title="MH-p")
p_MHP

#MF-ts
MF <- subset(data, data$V1== '3.MF')
MF
p_MF <- ggplot(MF,aes(x = MF$V2, y= MF$V3) ) + 
  geom_tile(data = subset(MF,  !is.null(MF$V11)), aes(fill= MF$V11) ) +
  theme_classic() + 
  ylim(c(-0.5,3.5)) + 
  geom_text(data=MF, aes(MF$V2, MF$V3, label = round(MF$V11,2))) + 
  theme(aspect.ratio=1) + 
  scale_fill_gradient(low = "#EDF0E6",
                      high = "#103D55",
                      guide = "colorbar",limits=c(0,1)) + 
  labs(title="MF-ts")
p_MF

#DM-ts
DM <- subset(data, data$V1== '14.DM')
DM
p_DM <- ggplot(DM,aes(x = DM$V2, y= DM$V3) ) + 
  geom_tile(data = subset(DM,  !is.null(DM$V11)), aes(fill= DM$V11) ) +
  theme_classic() + 
  ylim(c(-0.5,3.5)) + 
  geom_text(data=DM, aes(DM$V2, DM$V3, label = round(DM$V11,2))) + 
  theme(aspect.ratio=1) + 
  scale_fill_gradient(low = "#EDF0E6",
                      high = "#103D55",
                      guide = "colorbar",limits=c(0,1)) + 
  labs(title="DM-ts")
p_DM

#MT2-ts
MT <- subset(data, data$V1== '4.MT')
MT
p_MT <- ggplot(MT,aes(x = MT$V2, y= MT$V3) ) + 
  geom_tile(data = subset(MT,  !is.null(MT$V11)), aes(fill= MT$V11) ) +
  theme_classic() + 
  ylim(c(-0.5,3.5)) + 
  geom_text(data=MT, aes(MT$V2, MT$V3, label = round(MT$V11,2))) + 
  theme(aspect.ratio=1) + 
  scale_fill_gradient(low = "#EDF0E6",
                      high = "#103D55",
                      guide = "colorbar",limits=c(0,1)) + 
  labs(title="MT2-ts")
p_MT

#MT-p
MTP <- subset(data, data$V1== '5.MT_P')
MTP
p_MTP <- ggplot(MTP,aes(x = MTP$V2, y= MTP$V3) ) + 
  geom_tile(data = subset(MTP,  !is.null(MTP$V11)), aes(fill= MTP$V11) ) +
  theme_classic() + 
  ylim(c(-0.5,3.5)) + 
  geom_text(data=MTP, aes(MTP$V2, MTP$V3, label = round(MTP$V11,2))) + 
  theme(aspect.ratio=1) + 
  scale_fill_gradient(low = "#EDF0E6",
                      high = "#103D55",
                      guide = "colorbar",limits=c(0,1)) + 
  labs(title="MT-p")
p_MTP

#HC20-ts

HC20 <- subset(data, data$V1== '7.HC20')
HC20
p_HC20 <- ggplot(HC20,aes(x = HC20$V2, y= HC20$V3) ) + 
  geom_tile(data = subset(HC20,  !is.null(HC20$V11)), aes(fill= HC20$V11) ) +
  theme_classic() + 
  ylim(c(-0.5,3.5)) + 
  geom_text(data=HC20, aes(HC20$V2, HC20$V3, label = round(HC20$V11,2))) + 
  theme(aspect.ratio=1) + 
  scale_fill_gradient(low = "#EDF0E6",
                      high = "#103D55",
                      guide = "colorbar",limits=c(0,1)) + 
  labs(title="HC20-ts")
p_HC20

#HC200-ts
HC200 <- subset(data, data$V1== '12.HC200')
HC200
p_HC200 <- ggplot(HC200,aes(x = HC200$V2, y= HC200$V3) ) + 
  geom_tile(data = subset(HC200,  !is.null(HC200$V11)), aes(fill= HC200$V11) ) +
  theme_classic() + 
  ylim(c(-0.5,3.5)) + 
  geom_text(data=HC200, aes(HC200$V2, HC200$V3, label = round(HC200$V11,2), size = 40)) + 
  theme(aspect.ratio=1) + 
  scale_fill_gradient(low = "#EDF0E6",
                      high = "#103D55",
                      guide = "colorbar",limits=c(0,1)) + 
  labs(title="HC200-ts")
p_HC200


#M2S2MH
MSM <- subset(data, data$V1== '13.MSM')
MSM
#MH_null <- subset(MH, MH$V11 == 'null')
p_MSM <- ggplot(MSM,aes(x = MSM$V2, y= MSM$V3) ) + 
  geom_tile(data = subset(MSM,  !is.null(MSM$V11)), aes(fill= MSM$V11) ) + 
  #geom_tile(data=MH_null, aes(x = MH_null$V2, y= MH_null$V3,fill='pink')) + 
  theme_classic() + 
  ylim(c(-0.5,3.5)) + 
  geom_text(data=MSM, aes(MSM$V2, MSM$V3, label = round(MSM$V11,2))) + 
  theme(aspect.ratio=1) + 
  scale_fill_gradient(low = "#EDF0E6",
                      high = "#103D55",
                      guide = "colorbar",limits=c(0,1)) + 
  labs(title="M2S2MH")
p_MSM


ggarrange( p_MH, p_MHP, p_MF, p_DM, p_MT,p_MTP, p_HC20, p_HC200, p_MSM,
           ncol = 3,nrow=3,
           common.legend = TRUE )