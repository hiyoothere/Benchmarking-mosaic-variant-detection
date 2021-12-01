#!/bin/bash

ID_con=$1
ID_cas=$2
POS=$3
DATA=$4
AnalysisPath=$5
script=$6


if [ ! -d $AnalysisPath ]
then 
	mkdir -p -m 770 $AnalysisPath
fi

 
python $script/3.script.MH_final.py $POS $ID_con $ID_cas $DATA $AnalysisPath

