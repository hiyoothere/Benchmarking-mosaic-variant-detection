#!/bin/bash


REF=$1
DataPath=$2
ID_con=$3
ID_cas=$4
INTERVAL=$5
AnalysisPath=$6

MantaPath=/opt/Yonsei/Manta/1.6.0/bin


if [ ! -d $AnalysisPath ]
then 
	mkdir -p -m 770 $AnalysisPath
fi

rm -rf ${AnalysisPath}/${ID_cas}_${ID_con}

if [[ $ID_con == *"D"* ]];#Downsample
then
	if [[ $DataPath == *"Mixed"* ]];then #DS_mx
		echo "Downsample_mx"
		$MantaPath/configManta.py \
		--tumorBam=$DataPath/$ID_cas'.LA.bam' \
		--normalBam=$DataPath/$ID_con'.LA.bam' \
		--referenceFasta=$REF \
		--callRegions=$INTERVAL".gz" \
		--runDir=${AnalysisPath}/${ID_cas}_${ID_con}
		
		${AnalysisPath}/${ID_cas}_${ID_con}/runWorkflow.py -m local -j 20
	else #DS_tp
		echo "Downsample_tp"
		$MantaPath/configManta.py \
                --tumorBam=$DataPath/$ID_cas'.MRS.s.RGadd.LA.bam' \
                --normalBam=$DataPath/$ID_con'.MRS.s.RGadd.LA.bam' \
                --referenceFasta=$REF \
                --callRegions=$INTERVAL".gz" \
                --runDir=${AnalysisPath}/${ID_cas}_${ID_con}
        
                ${AnalysisPath}/${ID_cas}_${ID_con}/runWorkflow.py -m local -j 20
	fi
else ## Whole
	if [[ $DataPath == *"Mixed"* ]];then #whole_mx
		echo "whole_mx"
		$MantaPath/configManta.py \
	        --tumorBam=$DataPath/$ID_cas'_RF_il_WES.RGadded.marked.realigned.fixed.recal.LA.bam' \
	        --normalBam=$DataPath/$ID_con'_RF_il_WES.RGadded.marked.realigned.fixed.recal.LA.bam' \
	        --referenceFasta=$REF \
	        --callRegions=$INTERVAL".gz" \
	        --runDir=${AnalysisPath}/${ID_cas}_${ID_con}
	
	        ${AnalysisPath}/${ID_cas}_${ID_con}/runWorkflow.py -m local -j 20
	else #whole_tp
		echo "whole_tp"
		$MantaPath/configManta.py \
                --tumorBam=$DataPath/$ID_cas'.MRS.s.RGadd.LA.bam' \
                --normalBam=$DataPath/$ID_con'.MRS.s.RGadd.LA.bam' \
                --referenceFasta=$REF \
                --callRegions=$INTERVAL".gz" \
                --runDir=${AnalysisPath}/${ID_cas}_${ID_con}

                ${AnalysisPath}/${ID_cas}_${ID_con}/runWorkflow.py -m local -j 20
	fi
fi


