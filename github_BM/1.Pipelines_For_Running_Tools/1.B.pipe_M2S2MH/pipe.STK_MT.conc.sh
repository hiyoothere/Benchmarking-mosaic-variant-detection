#!/bin/bash

ID_con=$1
ID_cas=$2
AnalysisPath=$3
STKpath=$4
MTpath=$5
script=$6

echo $STKpath

if [ ! -d $AnalysisPath ]
then 
	mkdir -p -m 770 $AnalysisPath
fi


#MT_snv=$MTpath/${ID_cas}"_"${ID_con}".filtered.Share.PASS.vcf"
MT_snv=$MTpath/${ID_cas}"_"${ID_con}".vcf"
STK_snv=$STKpath/${ID_cas}"_"${ID_con}"/results/variants/somatic.snvs.PASS.vcf"
OUT_snv=$AnalysisPath/${ID_cas}"_"${ID_con}".snvs.PASS.vcf"
python $script/python.STK_MT_conc.py $MT_snv $STK_snv $OUT_snv 


#
##MT_indel=$MTpath/${ID_cas}"_"${ID_con}".filtered.Share.PASS.vcf"
#MT_indel=$MTpath/${ID_cas}"_"${ID_con}".vcf"
#STK_indel=$STKpath/${ID_cas}"_"${ID_con}"/results/variants/somatic.indels.PASS.vcf"
#OUT_indel=$AnalysisPath/${ID_cas}"_"${ID_con}".indels.PASS.vcf"
#python $script/python.STK_MT_conc.py $MT_indel $STK_indel $OUT_indel




