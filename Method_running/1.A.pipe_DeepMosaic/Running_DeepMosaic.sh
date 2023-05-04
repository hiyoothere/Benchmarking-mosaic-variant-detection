#!/bin/bash
#$ -cwd

INPUT=$1 #Input dir
OUTPUT=$2 #Output dir
DM_path=$3 #DeepMosaic dir


if [ ! -d $DIR/out ]
	then
		mkdir -p $DIR/out
	fi

## depth arr
dp_arr=("whole" "D1" "D2" "D3") #1000X, 125x, 250x, 500x respectively

## sample arr
samp_arr=("M1" "M2" "M3")

## mxtp arr
mxtp=("SetA" "SetB")
for dp in ${dp_arr[*]};
do
	for samp in ${samp_arr[*]};do
		for type in ${mxtp[*]};do
			jobID="${dp}_${samp}_${type}"		
			qsub -o $DIR/out -e $DIR/out -N ${jobID}.step1 -pe smp 1 $DIR/DM_step1.sh \
			$DM_path $INPUT $dp $samp $type $OUTPUT
			
			qsub -q gpu.q -o $DIR/out -e $DIR/out -N ${jobID}.step2 -hold_jid ${jobID}.step1 -pe smp 1 $DIR/DM_step2.sh \
			$DM_path $INPUT $dp $samp $type $OUTPUT		
		done
	done
	break
done

