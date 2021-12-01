#!/bin/bash





#### DEPTH 5, 95th percentile
DataPath=/data/project/MRS/4.Analysis_Mosaic/GATK/VCF/mx/
BED=/data/project/MRS/script/TargetRegion/SureSelect_v5.hg38.new.bed
AnalysisPath=/data/project/MRS/4.Analysis_Mosaic/13.MSM/interim/mx
outfile=$AnalysisPath/depth.5.95.txt
qsub -pe smp 5 -e $DIR/out/mx/ -o $DIR/out/mx/ -N 'depth_interval' $DIR/script/MSM/pipe.depth_interval.sh \
$AnalysisPath $outfile $DIR/script/MSM $DataPath $BED
sleep 1



#ID_con=$1
#ID_cas=$2
#DataPath=$3
#OUT=$4
#FILTER=$5
#script=$6
#
#if [ ! -d $OUT/interim ]
#then 
#	mkdir -p -m 770 $OUT/interim
#fi
#
#echo $OUT/interm
#cas_IND=$FILTER/"ND.${ID_cas}.HC.Ploidy2.fil.ind.5pad.s.merge.bed"
##con_IND=$FILTER/"ND.${ID_con}.HC.Ploidy2.fil.ind.5pad.s.merge.bed"
#
#DATA=$(ls $DataPath  |  egrep  "${ID_cas}_${ID_con}" )
#DATA_LIST=(${DATA// / })
#for idx in ${!DATA_LIST[@]};
#do
#	Data=${DATA_LIST[idx]}
#		
#	sed -i '1s/^/##fileformat=VCFv4.2\n/' $DataPath/$Data #add header for fileformat(VCF)
#	
#	sleep 1
#	###remove rp.bed | only provide high confidence PC
#	bedtools intersect \
#	        -a $DataPath/${Data} \
#	        -b $cas_IND \
#	        -v > $OUT/${Data}
#	sleep 1
#	
#	#sed -i '1s/^/##fileformat=VCFv4.2\n/' $OUT/interim/${Data%.vcf}".rem_${ID_cas}.vcf"
#	#bedtools intersect \
#        #        -a $OUT/interim/${Data%.vcf}".rem_${ID_cas}.vcf" \
#        #        -b $con_IND \
#        #        -v > $OUT/${Data}
#	#
#	
#done



