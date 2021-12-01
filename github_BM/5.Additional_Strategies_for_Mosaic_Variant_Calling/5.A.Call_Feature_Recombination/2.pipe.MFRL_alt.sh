#!/bin/bash
#$ -cwd

script=$1
AnalysisPath=$2
infile=$3
outfile=$4

python $script/2.script.MFRL_alt.py $AnalysisPath $infile $outfile


