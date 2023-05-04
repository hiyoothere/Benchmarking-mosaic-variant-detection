#!/bin/bash
#$ -cwd

REF=$1
InputPath=$2 # input for MosaicForecast (e.g., sample_input)
AnalysisPath=$3 #output dir
ID=$4
MF_Path=$5



#MosaicForecast snv prediction
#1.1 feature extraction
python3 $MF_Path/ReadLevel_Features_extraction.py \
$InputPath/mx/$ID'.snv.input' \
$AnalysisPath$ID/$ID'.features' \
$DataPath \
$REF \
$MF_Path/resources/$k24.umap.wg.bw  2 bam

#1.2 prediction
Rscript  $MF_Path/Prediction.R \
$AnalysisPath/$ID/$ID'.features' \
$MF_Path/models_trained/250xRFmodel_addRMSK_Refine.rds \
Refine \
$AnalysisPath/$ID/$ID'.SNP.Predictions'

#1.3 final output
cat $AnalysisPath/$ID/$ID'.SNP.Predictions' | grep mosaic | grep SNP > $AnalysisPath/$ID/$ID'.SNP.Predictions.mosaic'



##MosaicForecast indel prediction
#2.1 feature extraction
python3 $MF_Path/ReadLevel_Features_extraction.py \
$InputPath/mx/$ID'.ind.input' \
$AnalysisPath'ind.'$ID/$ID'.features' \
$DataPath \
$REF \
$MF_Path/resources/k24.umap.wg.bw  2 bam

#2.2 prediction of deletions
Rscript  $MF_Path/Prediction.R \
$AnalysisPath/'ind.'$ID/$ID'.features' \
$MF_Path/models_trained/deletions_250x.RF.rds \
Refine \
$AnalysisPath/'ind.'$ID/$ID'.DEL.Predictions'

#2.3 prediction of insertions
Rscript  $MF_Path/Prediction.R \
$AnalysisPath/'ind.'$ID/$ID'.features' \
$MF_Path/models_trained/insertions_250x.RF.rds \
Refine \
$AnalysisPath/'ind.'$ID/$ID'.INS.Predictions'

#2.4 final output
cat $AnalysisPath/'ind.'$ID/$ID'.DEL.Predictions' | egrep 'hap=3' | grep DEL > $AnalysisPath/'ind.'$ID/$ID'.DEL.Predictions.mosaic'

cat $AnalysisPath/'ind.'$ID/$ID'.INS.Predictions' | egrep 'hap=3' | grep INS > $AnalysisPath/'ind.'$ID/$ID'.INS.Predictions.mosaic'

cat $AnalysisPath/'ind.'$ID/$ID'.DEL.Predictions.mosaic' $AnalysisPath/'ind.'$ID/$ID'.INS.Predictions.mosaic' > $AnalysisPath/'ind.'$ID/$ID'.IND.Predictions.mosaic'


