#!/bin/bash
#$ -cwd


ID_con=$1
ID_cas=$2
DataPath=$3
OUT=$4

#filtering reference files
REPEAT=/data/project/MRS/script/region_clus_sRepeat_segdup/region_sRepeat_segdup.201026.s.m.pad.bed


if [ ! -d $OUT ]
then 
	mkdir -p -m 770 $OUT
fi

#echo $DataPath
#echo $OUT
#echo "${ID_cas}_${ID_con}."
DATA=$( ls $DataPath  |  egrep  "${ID_cas}_${ID_con}."  |  egrep -v ".s.vcf" )
#echo $DATA
DATA_LIST=(${DATA// / })
#echo $DATA_LIST
for idx in ${!DATA_LIST[@]};
do
	
	Data=${DATA_LIST[idx]}

	echo $Data	
	
	
	sort -k1,1V -k2,2g $DataPath/${Data} > $DataPath/${Data%.vcf}.s.vcf #sort VCF	
	sleep 1
	
	sed -i '1s/^/##fileformat=VCFv4.2\n/' $DataPath/${Data%.vcf}.s.vcf #add header for fileformate (VCF)

	rm -rf $OUT/${Data}
	sleep 1	
	
	echo $OUT/${Data}	
	###remove rp.bed | only provide high confidence PC
	bedtools intersect \
	        -a $DataPath/${Data%.vcf}.s.vcf \
	        -b $REPEAT \
	        -v > $OUT/${Data}
	
	
done



