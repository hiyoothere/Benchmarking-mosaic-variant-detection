library(nVennR)
src_dir <- setwd("C://Temp/MRS_final/euler/SNV_3")
src_file <- list.files(src_dir, pattern = ".txt")
src_file

for(idx in 1:length(src_file)){
  df <- read.table(src_file[idx], header = TRUE)
  pdf(file=paste0("output/",src_file[idx],".pdf"), width = 4, height = 4)
  myV <- createVennObj(nSets = 4, sNames = c('ND', 'D1', 'D2', 'D3'))
  print(src_file[idx])
  for(i in 1:nrow(df)){
    combination <- unlist(strsplit(as.vector(df[i,1]),'&'))
    number <- as.numeric(df[i,2])
    myV <- setVennRegion(myV, combination, number)
  }
  plotVenn(nVennObj = myV)
  dev.off()
}







