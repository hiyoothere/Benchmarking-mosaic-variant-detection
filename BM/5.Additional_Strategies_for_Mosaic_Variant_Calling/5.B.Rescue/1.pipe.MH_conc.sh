#!/bin/bash

ID_con=$1
ID_cas=$2
MH=$3
AnalysisPath=$4
script=$5
DP=$6

if [ ! -d $AnalysisPath ]
then 
	mkdir -p -m 770 $AnalysisPath
fi

 
echo $DP
python $script/1.script.MH_conc.py $MH $ID_con $ID_cas $AnalysisPath $DP
sleep 3

