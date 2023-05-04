#!/bin/bash

ID_con=$1
ID_cas=$2
DataPath=$3

if [ ! -d $DataPath/temp ]
then 
	mkdir -p -m 770 $DataPath/temp
fi

## create case.txt, ctrl.txt 
POS=$(ls $DataPath |  egrep  "${ID_cas}_${ID_con}_" | egrep -v "ctrl|case|total" )
POS_LIST=(${POS// / })
#echo $POS_LIST
for idx in ${!POS_LIST[@]};
do
        pos=${POS_LIST[idx]}
      	#echo $pos 
	if [[ $pos == *"${ID_cas}_${ID_con}_${ID_cas}"* ]]
	then
		rm -rf $DataPath/${pos%.txt}.case.txt ## remove previous to not overwrite

		mv $DataPath/$pos $DataPath/${pos%.txt}.case.txt
	else
		rm -rf $DataPath/${pos%.txt}.ctrl.txt

		mv $DataPath/$pos $DataPath/${pos%.txt}.ctrl.txt
	fi
	


done


### create total.txt
cat $DataPath/"${ID_cas}_${ID_con}_"*".txt" $DataPath/"${ID_cas}_${ID_con}.sha.txt"  > $DataPath/temp/"${ID_cas}_${ID_con}.total.txt"
sleep 2

sort -k1,1V -k2,2g $DataPath/temp/"${ID_cas}_${ID_con}.total.txt"  > $DataPath/"${ID_cas}_${ID_con}.total.txt"

