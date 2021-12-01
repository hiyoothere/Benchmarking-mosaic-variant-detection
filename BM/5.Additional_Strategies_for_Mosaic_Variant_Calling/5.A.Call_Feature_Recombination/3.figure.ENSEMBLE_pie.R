#!/opt/Yonsei/R/4.0.2/bin/R

library(ggplot2)
library(readxl)
library(scales)
library(cowplot)
library(gridExtra)


### Input Arguments 
args = commandArgs(trailingOnly=TRUE)
if(length(args)==3) {
        WD=as.character(args[1])
        infile=as.character(args[2])
	outfile=as.character(args[3])
} else {
        stop("ERROR: Invalid number of input parameters", call.=TRUE)
}


setwd(WD)

#df <- read_excel("ENSEMBLE_data.xlsx", sheet =1)
df <- read.delim(infile)

df$per <- (df$COUNT/df$TOTAL)
stackorder <-c("PASSED", "FILTERED")


######### ALT  SOFTCLIP : MT call _ MF RAW
d1 <- subset(df, FEATURE == "alt_softclip" & TYPE == "TP")
p1 <- ggplot(d1, aes(x = "", y=as.numeric(per), order=stackorder, fill = WHEN ))+
  geom_bar( stat = "identity", width =1, 
            fill = c("#54D0E0", "#EB7263"),
            color = "grey60"
            )+
  coord_polar("y", start = 0, direction = -1)+
  ggtitle("[Alt softclip] TP")+
  labs(x = "", y = "")+
  theme_void()+
  theme(axis.text.x=element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")+
  geom_text(aes(x=1, y= cumsum(per) - per/2, 
                label = paste(as.character(COUNT), 
                              paste("(", substr(as.character(per*100),1,5),"%", ")", sep = ""), 
                              sep="\n")
                ))

d2 <- subset(df, FEATURE == "alt_softclip" & TYPE == "FP")
p2 <- ggplot(d2, aes(x = "", y=as.numeric(per), order=stackorder, fill = WHEN ))+
  geom_bar( stat = "identity", width =1, 
            fill = c("#54D0E0", "#EB7263"),
            color = "grey60"
  )+
  coord_polar("y", start = 0, direction = -1)+
  ggtitle("[Alt softclip] FP")+
  labs(x = "", y = "")+
  theme_void()+
  theme(axis.text.x=element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")+
  geom_text(aes(x=1, y= cumsum(per) - per/2, 
                label = paste(as.character(COUNT), 
                              paste("(", substr(as.character(per*100),1,5),"%", ")", sep = ""), 
                              sep="\n")
  ))

#### MFRL ALT : HC200 call _ MT feature
d3 <- subset(df, FEATURE == "MFRL_alt" & TYPE == "TP")
p3 <- ggplot(d3, aes(x = "", y=as.numeric(per), order=stackorder, fill = WHEN ))+
  geom_bar( stat = "identity", width =1, 
            fill = c("#54D0E0", "#EB7263"),
            color = "grey60"
  )+
  coord_polar("y", start = 0, direction = -1)+
  ggtitle("[MFRL alt] TP")+
  labs(x = "", y = "")+
  theme_void()+
  theme(axis.text.x=element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")+
  geom_text(aes(x=1, y= cumsum(per) - per/2, 
                label = paste(as.character(COUNT), 
                              paste("(", substr(as.character(per*100),1,5),"%", ")", sep = ""), 
                              sep="\n")
  ))

d4 <- subset(df, FEATURE == "MFRL_alt" & TYPE == "FP")
p4 <- ggplot(d4, aes(x = "", y=as.numeric(per), order=stackorder, fill = WHEN ))+
  geom_bar( stat = "identity", width =1, 
            fill = c("#54D0E0", "#EB7263"),
            color = "grey60"
  )+
  coord_polar("y", start = 0, direction = -1)+
  ggtitle("[MFRL alt] FP")+
  labs(x = "", y = "")+
  theme_void()+
  theme(axis.text.x=element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")+
  geom_text(aes(x=1, y= cumsum(per) - per/2, 
                label = paste(as.character(COUNT), 
                              paste("(", substr(as.character(per*100),1,5),"%", ")", sep = ""), 
                              sep="\n")
  ))

###### HEt LIKELIHOOD :  HC200 call _ MF RAW
d5 <- subset(df, FEATURE == "het_likelihood" & TYPE == "TP")
p5 <- ggplot(d5, aes(x = "", y=as.numeric(per), order=stackorder, fill = WHEN ))+
  geom_bar( stat = "identity", width =1, 
            fill = c("#54D0E0", "#EB7263"),
            color = "grey60"
  )+
  coord_polar("y", start = 0, direction = -1)+
  ggtitle("[Het likelihood] TP")+
  labs(x = "", y = "")+
  theme_void()+
  theme(axis.text.x=element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")+
  geom_text(aes(x=1, y= cumsum(per) - per/2, 
                label = paste(as.character(COUNT), 
                              paste("(", substr(as.character(per*100),1,5),"%", ")", sep = ""), 
                              sep="\n")
  ))

d6 <- subset(df, FEATURE == "het_likelihood" & TYPE == "FP")
p6 <- ggplot(d6, aes(x = "", y=as.numeric(per), order=stackorder, fill = WHEN ))+
  geom_bar( stat = "identity", width =1, 
            fill = c("#54D0E0", "#EB7263"),
            color = "grey60"
  )+
  coord_polar("y", start = 0, direction = -1)+
  ggtitle("[Het likelihood] FP")+
  labs(x = "", y = "")+
  theme_void()+
  theme(axis.text.x=element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")+
  geom_text(aes(x=1, y= cumsum(per) - per/2, 
                label = paste(as.character(COUNT), 
                              paste("(", substr(as.character(per*100),1,5),"%", ")", sep = ""), 
                              sep="\n")
  ))



#FINAL <- grid.arrange(p1, p2, p3, p4, p5, p6, nrow=1)

pdf(file = outfile, width = 24, height =5)
grid.arrange(p1, p2, p3, p4, p5, p6, nrow=1)
dev.off()





















