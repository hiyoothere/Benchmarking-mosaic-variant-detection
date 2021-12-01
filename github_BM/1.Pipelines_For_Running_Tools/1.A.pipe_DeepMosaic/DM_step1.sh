#!/bin/bash
#$ -cwd

DM_path=$1
IN_path=$2
dp=$3
samp=$4
mxtp=$5
OUT_path=$6
ANNOVAR="/data/project/MRS/Resource/ANNOVAR/2019-10-24/humandb"
rm -rf "${ANNOVAR}/hg38_gnomad_genome.txt"
ln -s "${ANNOVAR}/hg38_gnomad_genome.${samp}.rem.txt" "${ANNOVAR}/hg38_gnomad_genome.txt"
sleep 1
if [[ "whole" =~ $dp ]]
then
	$DM_path/deepmosaic/deepmosaic-draw \
	-i $IN_path/input_${dp}_${samp}_${mxtp}.txt \
	-o $OUT_path/0.DF/${mxtp}/${samp} \
	-a "/data/project/MRS/Resource/ANNOVAR/2019-10-24" \
	-t 3 \
	-b hg38
else
	$DM_path/deepmosaic/deepmosaic-draw \
	-i $IN_path/input_${dp}_${samp}_${mxtp}.txt \
	-o $OUT_path/2.DS/${mxtp}/${dp}_${samp} \
	-a /data/project/MRS/Resource/ANNOVAR/2019-10-24 \
	-t 3 \
	-b hg38
fi
