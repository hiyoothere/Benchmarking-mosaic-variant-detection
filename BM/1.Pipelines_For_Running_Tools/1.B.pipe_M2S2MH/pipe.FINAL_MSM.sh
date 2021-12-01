#!/bin/bash

ID_con=$1
ID_cas=$2
MS=$3
MH=$4
AnalysisPath=$5
script=$6


if [ ! -d $AnalysisPath ]
then 
	mkdir -p -m 770 $AnalysisPath
fi


POS=$(ls $MH |  egrep  "${ID_cas}_${ID_con}.sha" )
POS_LIST=(${POS// / })
#echo $POS_LIST
for idx in ${!POS_LIST[@]};
do
        pos=${POS_LIST[idx]}
        echo $pos

	rm -rf $AnalysisPath/$pos
        ln -s $MH/$pos $AnalysisPath/$pos

done

python $script/python.FINAL_MSM.py $ID_con $ID_cas $MS $MH $AnalysisPath

