#!/bin/bash

ID_con=$1
ID_cas=$2
DataPath=$3

if [ ! -d $DataPath/temp ]
then 
	mkdir -p -m 770 $DataPath/temp
fi


#POS=$(ls $DataPath |  egrep  "${ID_cas}_${ID_con}_" | egrep -v "ctrl|case|total" )
#POS_LIST=(${POS// / })
#echo $POS_LIST
#for idx in ${!POS_LIST[@]};
#do
#        pos=${POS_LIST[idx]}
#      	#echo $pos 
#	if [[ $pos == *"${ID_cas}_${ID_con}_${ID_cas}"* ]]
#	then
#		rm -rf $DataPath/${pos%.txt}.case.txt
#
#		mv $DataPath/$pos $DataPath/${pos%.txt}.case.txt
#	else
#		rm -rf $DataPath/${pos%.txt}.ctrl.txt
#
#		mv $DataPath/$pos $DataPath/${pos%.txt}.ctrl.txt
#	fi
#	
#
#
#done

echo $DataPath
   
#cat $DataPath/"${ID_cas}_${ID_con}_"*".FP."*".txt" $DataPath/"${ID_cas}_${ID_con}.FP.sha.txt"  > $DataPath/temp/"${ID_cas}_${ID_con}.total.txt"
cat $DataPath/"${ID_cas}_${ID_con}_"*"FP.sha.txt" $DataPath/"${ID_cas}_${ID_con}."*"FP.sha.txt" > $DataPath/temp/"${ID_cas}_${ID_con}.total.sha.FP.txt"
sleep 2
sort -k3,3V -k4,4g $DataPath/temp/"${ID_cas}_${ID_con}.total.sha.FP.txt"  > $DataPath/"${ID_cas}_${ID_con}.total.sha.FP.txt"

cat $DataPath/"${ID_cas}_${ID_con}_"*"TP.sha.txt" $DataPath/"${ID_cas}_${ID_con}."*"TP.sha.txt" > $DataPath/temp/"${ID_cas}_${ID_con}.total.sha.TP.txt"
sleep 2
sort -k3,3V -k4,4g $DataPath/temp/"${ID_cas}_${ID_con}.total.sha.TP.txt"  > $DataPath/"${ID_cas}_${ID_con}.total.sha.TP.txt"
sort -k3,3V -k4,4g $DataPath/temp/"${ID_cas}_${ID_con}.total.sha.FP.txt"  > $DataPath/"${ID_cas}_${ID_con}.total.sha.FP.txt"

#rm -rf $DataPath/temp

