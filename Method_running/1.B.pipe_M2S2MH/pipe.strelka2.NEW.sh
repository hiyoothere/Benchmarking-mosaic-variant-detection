#!/bin/bash



REF=$1
DataPath=$2
ID_con=$3
ID_cas=$4
INTERVAL=$5
AnalysisPath=$6
MantaPath=$7

if [ ! -d $AnalysisPath ]
then
        mkdir -p -m 770 $AnalysisPath
fi

StrelkaPath=/opt/Yonsei/Strelka2/2.9.10/bin
#AnalysisPath=/data/project/MRS/4.Analysis_Mosaic/STK/

rm -rf ${AnalysisPath}/${ID_cas}_${ID_con}


if [[ $ID_con == *"D"* ]] ### DOWNSAMPLE
then
	if [[ $DataPath == *"Mixed"* ]];then ##### DS_mx 
		echo "Downsample_mx"
		$StrelkaPath/configureStrelkaSomaticWorkflow.py \
		--tumorBam=$DataPath/$ID_cas'.LA.bam' \
		--normalBam=$DataPath/$ID_con'.LA.bam' \
		--referenceFasta=$REF \
		--indelCandidates=${MantaPath}/${ID_cas}_${ID_con}/results/variants/candidateSmallIndels.vcf.gz \
		--exome \
		--runDir=${AnalysisPath}/${ID_cas}_${ID_con} \
		--callRegions=$INTERVAL".gz"
		
		${AnalysisPath}/${ID_cas}_${ID_con}/runWorkflow.py -m local -j 20
	else #### DS_tp
		echo "Downsample_tp"
		$StrelkaPath/configureStrelkaSomaticWorkflow.py \
                --tumorBam=$DataPath/$ID_cas'.MRS.s.RGadd.LA.bam' \
                --normalBam=$DataPath/$ID_con'.MRS.s.RGadd.LA.bam' \
                --referenceFasta=$REF \
                --indelCandidates=${MantaPath}/${ID_cas}_${ID_con}/results/variants/candidateSmallIndels.vcf.gz \
                --exome \
                --runDir=${AnalysisPath}/${ID_cas}_${ID_con} \
                --callRegions=$INTERVAL".gz"
        
                ${AnalysisPath}/${ID_cas}_${ID_con}/runWorkflow.py -m local -j 20
	fi
else ### WHOLE
	if [[ $DataPath == *"Mixed"* ]];then #### whole_mx
		echo "whole_mx"
		$StrelkaPath/configureStrelkaSomaticWorkflow.py \
	        --tumorBam=$DataPath/$ID_cas'_RF_il_WES.RGadded.marked.realigned.fixed.recal.LA.bam' \
	        --normalBam=$DataPath/$ID_con'_RF_il_WES.RGadded.marked.realigned.fixed.recal.LA.bam' \
	        --referenceFasta=$REF \
	        --indelCandidates=${MantaPath}/${ID_cas}_${ID_con}/results/variants/candidateSmallIndels.vcf.gz \
	        --exome \
	        --runDir=${AnalysisPath}/${ID_cas}_${ID_con} \
	        --callRegions=$INTERVAL".gz"
	else ##### whole_tp
		echo "whole_tp"
		$StrelkaPath/configureStrelkaSomaticWorkflow.py \
                --tumorBam=$DataPath/$ID_cas'.MRS.s.RGadd.LA.bam' \
                --normalBam=$DataPath/$ID_con'.MRS.s.RGadd.LA.bam' \
                --referenceFasta=$REF \
                --indelCandidates=${MantaPath}/${ID_cas}_${ID_con}/results/variants/candidateSmallIndels.vcf.gz \
                --exome \
                --runDir=${AnalysisPath}/${ID_cas}_${ID_con} \
                --callRegions=$INTERVAL".gz"
		
        ${AnalysisPath}/${ID_cas}_${ID_con}/runWorkflow.py -m local -j 2
	fi
fi	

