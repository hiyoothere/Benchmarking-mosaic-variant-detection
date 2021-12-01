#!/bin/bash

ID_con=$1
ID_cas=$2
MH=$3
PU=$4
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
	sleep 1	
	ln -s $MH/$pos $AnalysisPath/$pos
		
done

python $script/python.MH_sort_alt3.py $MH $ID_con $ID_cas $PU $AnalysisPath 

