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

 
#MS=$(ls $MT_STK |  egrep  "${ID_cas}_${ID_con}" )
#MS_LIST=(${MS// / })
#for idx in ${!MS_LIST[@]};
#do
#        ms=${MS_LIST[idx]}
#	
##	echo $MH
##	echo $ms
#        python $script/python.MH.af30_het.py $MT_STK/$ms $MH $ID_cas $ID_con $AnalysisPath/${ms}
#        sleep 3
#done
echo $DP
python $script/python.MH_conc.py $MH $ID_con $ID_cas $AnalysisPath $DP
sleep 3

