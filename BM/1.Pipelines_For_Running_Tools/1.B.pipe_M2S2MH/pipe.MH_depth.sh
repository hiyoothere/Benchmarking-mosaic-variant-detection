#!/bin/bash

ID_con=$1
ID_cas=$2
DataPath=$3
AnalysisPath=$4
DEPTH=$5
script=$6


if [ ! -d $AnalysisPath ]
then 
	mkdir -p -m 770 $AnalysisPath
fi

 
python $script/python.MH_depth.py $ID_con $ID_cas $DataPath $AnalysisPath $DEPTH

