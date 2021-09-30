#!/bin/bash
#$ -cwd



## mandatory argument
# 1. project name
PROJECT=MRS
MRS=/data/project/MRS
script=/home/jkim1105/jisoo_backup/3.BM_MSM

BED=$MRS/script/TargetRegion/SureSelect_v5.hg38.new.bed

depth=$script/depth

##DP_ls=("whole")
DP_ls=("D1" "D2" "D3")

log=$script/out
if [ ! -d $log ];then
	mkdir -p $log
fi

for DP in ${DP_ls[*]};do
	if [[ $DP == *"D"* ]];then
		DataPath=/data/project/MRS/4.Analysis_Mosaic/GATK/VCF.DS/tp/
		AnalysisPath=$depth/interim.${DP}
		outfile=${AnalysisPath}/depth.5.95.${DP}.txt
	else ### whole
		echo whole
		DataPath=/data/project/MRS/4.Analysis_Mosaic/GATK/VCF/tp/
		AnalysisPath=$depth/interim.whole
		outfile=$depth/depth.5.95.txt
	fi
		qsub -pe smp 5 -e $out -o $out -N "depth_interval.${DP}" $script/pipe.depth_interval.sh \
		$AnalysisPath $outfile $script $DataPath $BED $DP
		sleep 1
done




