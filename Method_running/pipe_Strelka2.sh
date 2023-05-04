#!/bin/bash

REF=$1
DataPath=$2
ID_cas=$3
ID_con=$4
INTERVAL=$5
AnalysisPath=$6
StrelkaPath=$7

$StrelkaPath/2.9.10/bin/configureStrelkaSomaticWorkflow.py \
--normalBam $DataPath/$ID_con'' \
--tumorBam $DataPath/$ID_cas'' \
--referenceFasta $REF \
--runDir $AnalysisPath/$ID_cas"_"$ID_con \
--callRegions $INTERVAL \
--exome \
--indelCandidates /data/project/MRS/4.Analysis_Mosaic/13.MSM/jkim_workspace/0.Manta/0.DF/mx/$ID_cas'_'$ID_con/results #Indel candidates from manta 
