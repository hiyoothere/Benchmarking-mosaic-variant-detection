library(ggplot2)
library(reshape)

data <- read.csv("/data/project/MRS/5.Combined_Analysis/Misclassification/Misclassification.txt",header=FALSE,sep='\t')
data
colnames(data) <- c('tool', 'ans', 'shared_call', 'percent_shared', 'misclassified', 'percent_miscla', 'pair')
data$fn <- data$ans - data$shared_call -data$misclassified
data$ratio_shared <- data$shared_call/data$ans
data$ratio_miscla <- data$misclassified/data$ans
data$ratio_fn <- data$fn/data$ans

data.ratio <- data[c("tool","ratio_shared", "ratio_miscla", "ratio_fn")]
data.ratio

data.ratio.melt <- melt(data.ratio, id = "tool")
data.ratio.melt.mis <- subset(data.ratio.melt, data.ratio.melt$variable == 'ratio_miscla')

data.ratio.melt
ggplot(data = data.ratio.melt, aes(x = value, y = factor(tool, levels = c("14.DM","1.MH","7.HC20", "12.HC200","13.MSM", "3.MF",  "4.MT")),
                                  fill = factor(variable,levels = c("ratio_miscla",  "ratio_fn","ratio_shared" )))) + 
  geom_bar(stat="identity") + 
  geom_text(aes(label=paste(round(value*100,0),"%")), position = position_stack(vjust = 0.2))+
  scale_fill_manual(values = c("darkblue", "gray", "orange")) + 
  labs(x = "Percentage of types",
       title = "Misclassification of shared mosaic variants") + 
  theme(aspect.ratio = 2)
