#!/bin/bash

AnalysisPath=$1
outfile=$2
script=$3
DataPath=$4
BED=$5
DP=$6

if [ ! -d $AnalysisPath ]
then 
	mkdir -p -m 770 $AnalysisPath
fi

if [[ $DP == *"D"* ]];then
	SNPS=$(ls $DataPath | egrep "${DP}" | egrep ".raw.snps.vcf" | egrep -v ".idx" )
	SNPS_LIST=(${SNPS// / })
else
        SNPS=$(ls $DataPath | egrep ".raw.snps.vcf" | egrep -v ".idx" )
        SNPS_LIST=(${SNPS// / })	
fi


for idx in ${!SNPS_LIST[@]};
do
        Data=${SNPS_LIST[idx]}

        bedtools intersect -wa -wb \
                -a $DataPath/${Data} \
                -b $BED \
                 > $AnalysisPath/${Data}
done
sleep 10

rm -rf $AnalysisPath/*.raw_snps.vcf

python $script/python.depth_selectRAND.py $AnalysisPath $outfile $DP

