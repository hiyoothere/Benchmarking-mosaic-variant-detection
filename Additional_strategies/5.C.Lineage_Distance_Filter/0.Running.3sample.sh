#!/bin/bash
#$ -cwd

DIR=/home/jkim1105
script=$DIR/jisoo_backup/8.BM_Fig5d


out=$script/out
if [ ! -d $out ]
then
	mkdir -p $out
fi


AnalysisPath=$script/results
if [ ! -d $AnalysisPath ]
then
	mkdir -p $AnalysisPath
fi

MT=/data/project/MRS/4.Analysis_Mosaic/4.MT

################################################################
### STEP 1 : extract TP and FP removal count txt################
################################################################

### whole.snv #1100x
DataPath=$MT/1.DF_A
qsub -pe smp 1 -e $out -o $out -N 'whole.snv' -hold_jid 'whole.snv' \
$script/1.pipe.removal_ct.sh \
$script $AnalysisPath $DataPath snv

### whole.ind #1100x
DataPath=$MT/7.IND_A
qsub -pe smp 1 -e $out -o $out -N 'whole.ind' -hold_jid 'whole.ind' \
$script/1.pipe.removal_ct.sh \
$script $AnalysisPath $DataPath ind

### DownSampled.snv 
#DataPath=$MT/3.DS_A
#qsub -pe smp 1 -e $out -o $out -N 'D2.snv' -hold_jid 'D2.snv' \
#$script/1.pipe.removal_ct.sh \
#$script $AnalysisPath $DataPath snv

### DownSampled.ind
#DataPath=$MT/8.IND_DS
#qsub -pe smp 1 -e $out -o $out -N 'D2.ind' -hold_jid 'D2.ind' \
#$script/1.pipe.removal_ct.sh \
#$script $AnalysisPath $DataPath ind






