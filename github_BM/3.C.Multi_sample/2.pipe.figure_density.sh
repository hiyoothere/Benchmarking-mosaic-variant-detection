#!/bin/bash
#$ -cwd

script=$1
AnalysisPath=$2
depth=$3

Rscript $script/2.figure.3sample_density.R $AnalysisPath $depth
