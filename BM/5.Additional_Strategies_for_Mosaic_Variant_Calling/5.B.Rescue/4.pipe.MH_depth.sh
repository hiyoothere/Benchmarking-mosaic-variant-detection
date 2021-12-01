#!/bin/bash

ID_con=$1
ID_cas=$2
DataPath=$3
AnalysisPath=$4
DEPTH=$5
script=$6
DM_DP=$7

if [ ! -d $AnalysisPath ]
then 
	mkdir -p -m 770 $AnalysisPath
fi


python $script/4.script.MH_depth.py $ID_con $ID_cas $DataPath $AnalysisPath $DEPTH $DM_DP

