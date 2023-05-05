#!/bin/bash

source "/home/gavehan/WORKSPACE/common/com_pipe.sh"

## Input Parameters
IN_SAMP=$1
IN_DS=$2
DEP=$3
SEED=$4
OUT_DIR=$5

## Key Variables
PICARD="/opt/Yonsei/Picard/2.23.1/picard.jar"

## Translate Input
mkdir -p $OUT_DIR
in_bam=$(grab_ts_bam "$IN_SAMP" "ND")
out_bam="${OUT_DIR}/${IN_DS}.${IN_SAMP}.MRS.s.RGadd.LA.bam"

## Main
echo "** Input: ${in_bam}"

og_dep="1100"
if [[ $og_dep ]]; then
    ds_ratio=$(echo "${DEP} / ${og_dep}" | bc -l)
    echo "** Original depth: ${og_dep}"
    echo "** Target depth: ${DEP}"
    echo "** Sampling fraction: ${ds_ratio}"
    if [[ -f $out_bam ]]; then
    	echo "${out_bam} exists"
    else
    	echo "** Generating ${out_bam}"
    	echo "****************"
    	java -jar "${PICARD}" DownsampleSam \
    	I="${in_bam}" \
    	O="${out_bam}" \
    	S="ConstantMemory" \
    	P="0${ds_ratio}" \
    	CREATE_INDEX="true" \
    	R="${SEED}"
    fi
    echo "** All operations complete"
else
    echo "ERROR: Failed to parse QM summary file"
    exit 1
fi
