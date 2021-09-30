#!/bin/bash
#$ -cwd

DIR=$1
ID=$2
AnalysisPath=$3
DataPath=$4
InputPath=$DIR/4.Analysis_Mosaic/3.MF/sample_input
MF_Path=/opt/Yonsei/MosaicForecast/0.0.1


#MosaicForecast snv prediction
#1.1 feature extraction
python3 $MF_Path/ReadLevel_Features_extraction.py \
$InputPath/mx/$ID'.snv.input' \
$AnalysisPath$ID/$ID'.features' \
$DataPath \
$DIR/Resource/reference/genome.fa \
$DIR/Resource/MF/k24.umap.wg.bw  2 bam

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
$DIR/Resource/reference/genome.fa \
$DIR/Resource/MF/k24.umap.wg.bw  2 bam

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


