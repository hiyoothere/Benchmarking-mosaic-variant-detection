#!/bin/bash


ID_con=$1
ID_cas=$2
DataPath=$3
OUT=$4
FILTER=$5
script=$6

if [ ! -d $OUT/interim ]
then 
	mkdir -p -m 770 $OUT/interim
fi

echo $OUT/interm

if [[ $ID_cas == *"D"* ]]
then
	IFS='.' read -r -a SAMPLE <<< "${ID_cas}"
	cas_IND=$FILTER/"ND.${SAMPLE[1]}.HC.Ploidy2.fil.ind.5pad.s.merge.bed"
else
	cas_IND=$FILTER/"ND.${ID_cas}.HC.Ploidy2.fil.ind.5pad.s.merge.bed"
fi
#con_IND=$FILTER/"ND.${ID_con}.HC.Ploidy2.fil.ind.5pad.s.merge.bed"

DATA=$(ls $DataPath  |  egrep  "${ID_cas}_${ID_con}" )
DATA_LIST=(${DATA// / })
for idx in ${!DATA_LIST[@]};
do
	Data=${DATA_LIST[idx]}
		
	sed -i '1s/^/##fileformat=VCFv4.2\n/' $DataPath/$Data #add header for fileformat(VCF)
	
	sleep 1
	###remove rp.bed | only provide high confidence PC
	bedtools intersect \
	        -a $DataPath/${Data} \
	        -b $cas_IND \
	        -v > $OUT/${Data}
	sleep 1
	
	#sed -i '1s/^/##fileformat=VCFv4.2\n/' $OUT/interim/${Data%.vcf}".rem_${ID_cas}.vcf"
	#bedtools intersect \
        #        -a $OUT/interim/${Data%.vcf}".rem_${ID_cas}.vcf" \
        #        -b $con_IND \
        #        -v > $OUT/${Data}
	#
	
done



