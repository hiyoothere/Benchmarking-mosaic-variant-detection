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

 
#POS=$(ls $MH |  egrep  "${ID_con}_${ID_cas}" | egrep "sha" )
#POS_LIST=(${POS// / })
##echo $POS_LIST
#for idx in ${!POS_LIST[@]};
#do
#        pos=${POS_LIST[idx]}
#	#echo $pos
#	
#	ln -s $MH/$pos $AnalysisPath/$pos
#		
#done
python $script/python.MH_final.py $POS $ID_con $ID_cas $DATA $AnalysisPath

