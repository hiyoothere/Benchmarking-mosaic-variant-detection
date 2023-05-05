setwd("feature_analysis/")
library(ggnewscale)
library(viridis)
library(ggpubr)
library(stringr)
library(dplyr)
library(FSelector)
library(pROC)
library(R.utils)
tool_features <- read.table("MT_mx_TPFP_feature.txt", header = TRUE, fill = TRUE)
tool_features$TP_FP <- as.factor(tool_features$TP_FP)
summary(tool_features)
#### type_SNV or INDEL for removing features not calculated #####
noNU <- c('ID','POPAF','AF') # MuTect
noNU <- c('ID','AC','AF','AN','DP','MLEAC','MLEAF','GQ') # HaplotypeCaller
noNU <- c('ID','pos','chrom','info','info1','name','sample','sex','ref','alt','variant','variant_type','gene_id','prediction','maf','lower_CI','upper_CI','gnomad','all_repeat','segdup','VAF') # DeepMosaic
noNU <- c('ID','type','context','prediction','length','AF','dp','refhom_post','het_post','repeat_post','mosaic_post','minor_mismatches_mean','major_mismatches_mean','mappability','sb_read12_p') # MosaicForecast
##################
tool_features <- tool_features %>% select(!noNU)
##################
AUC_DF <- data.frame(features=c(colnames(tool_features)[2:25]), AUC=NA)  # should change ":num" by each tools
pdf(file="ROC_setA/MF_mx.pdf", width = 8, height = 8)
for(i in 1:nrow(AUC_DF)){
  roc_result <- roc(tool_features$TP_FP, tool_features[,as.character(AUC_DF$features[i])])
  ifelse(roc_result$auc >= 0.5,roc_result,ifelse(roc_result$direction == ">", roc_result <- roc(tool_features$TP_FP, tool_features[,as.character(AUC_DF$features[i])], direction = "<"), roc_result <- roc(tool_features$TP_FP, tool_features[,as.character(AUC_DF$features[i])], direction = ">")))
  AUC_DF[i,'AUC'] <- roc_result$auc
  color <- ifelse(roc_result$auc >= 0.9, "red", "grey")
  if (i == 1) {
    plot.roc(roc_result, 
             col = color
             , print.auc = FALSE, max.auc.polygon = FALSE, 
             print.thres = FALSE, auc.polygon = FALSE)
  } else {
    plot.roc(roc_result, 
             col = color
             , print.auc = FALSE, max.auc.polygon = FALSE, 
             print.thres = FALSE, auc.polygon = FALSE, add = TRUE)
  }
}
dev.off()
AUC_DF <- AUC_DF[order(-AUC_DF$AUC),]
write.table(AUC_DF, file = 'ROC_setA/MF_mx.csv', quote = FALSE, sep = ',', col.names = T, row.names = F)
