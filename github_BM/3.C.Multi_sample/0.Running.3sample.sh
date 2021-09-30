#!/bin/bash
#$ -cwd

DIR=/home/jkim1105
script=$DIR/jisoo_backup/8.BM_Fig5d/8.BM_Fig5d.artifact_FPonly


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

### whole.snv
DataPath=$MT/1.DF_A
qsub -pe smp 1 -e $out -o $out -N 'whole.snv' -hold_jid 'whole.snv' \
$script/1.pipe.removal_ct.sh \
$script $AnalysisPath $DataPath snv

### whole.ind
DataPath=$MT/7.IND_A
qsub -pe smp 1 -e $out -o $out -N 'whole.ind' -hold_jid 'whole.ind' \
$script/1.pipe.removal_ct.sh \
$script $AnalysisPath $DataPath ind

### DS.snv
DataPath=$MT/3.DS_A
qsub -pe smp 1 -e $out -o $out -N 'D2.snv' -hold_jid 'D2.snv' \
$script/1.pipe.removal_ct.sh \
$script $AnalysisPath $DataPath snv

### DS.ind
DataPath=$MT/8.IND_DS
qsub -pe smp 1 -e $out -o $out -N 'D2.ind' -hold_jid 'D2.ind' \
$script/1.pipe.removal_ct.sh \
$script $AnalysisPath $DataPath ind


#################################################################################
## STEP 2 : plot density distribution of removal percentage  #################
#################################################################################
qsub -pe smp 1 -e $out -o $out -N 'figure.whole' -hold_jid 'figure.whole','whole.snv','whole.ind' \
$script/2.pipe.figure_density.sh \
$script $AnalysisPath whole

qsub -pe smp 1 -e $out -o $out -N 'figure.D2' -hold_jid 'figure.D2','D2.snv','D2.ind' \
$script/2.pipe.figure_density.sh \
$script $AnalysisPath D2





