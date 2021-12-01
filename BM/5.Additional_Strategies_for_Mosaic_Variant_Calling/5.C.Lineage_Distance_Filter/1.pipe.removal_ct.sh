#!/bin/bash
#$ -cwd

script=$1
AnalysisPath=$2
DataPath=$3
tag=$4

if [[ $DataPath == *"DS"* ]];then
	python $script/1.script.removal_ct.DS.py $DataPath $tag $AnalysisPath
else
	python $script/1.script.removal_ct.whole.py $DataPath $tag $AnalysisPath
fi

