#!/bin/bash

ID_con=$1
ID_cas=$2
AnalysisPath=$3
#INTERVAL=$4


### 2. PASS 
DataPath=$AnalysisPath/${ID_cas}_${ID_con}/results/variants
DATA=$(ls $DataPath  |  egrep  ".gz" | egrep -v "PASS" | egrep -v "tbi")
echo $DATA
DATA_LIST=(${DATA// / })
echo $DATA_SLIST
for idx in ${!DATA_LIST[@]};
do
	Data=${DATA_LIST[idx]}

	gunzip $DataPath/$Data  
	
	VCF=$DataPath/${Data%.gz}
	
	cat $VCF | egrep 'PASS|##file'  > ${VCF%.vcf}.PASS.vcf
	
	gzip $VCF 
done



