#!/bin/bash
#$ -cwd

DM_path=$1
IN_path=$2
dp=$3
samp=$4
mxtp=$5
OUT_path=$6

if [[ "whole" =~ $dp ]]
then
	$DM_path/deepmosaic/deepmosaic-predict \
	-i $OUT_path/0.DF/${mxtp}/${samp}/features.txt \
	-o $OUT_path/0.DF/${mxtp}/${samp}/output.txt
else	
        $DM_path/deepmosaic/deepmosaic-predict \
        -i $OUT_path/2.DS/${mxtp}/${dp}_${samp}/features.txt \
        -o $OUT_path/2.DS/${mxtp}/${dp}_${samp}/output.txt
fi	
