#!/bin/bash
#$ -cwd

MRS=/data/project/MRS

DIR=/home/jkim1105
script=$DIR/jisoo_backup/7.BM_Fig5a

### Input path of concordant positions of ensemble tools 
DataPath=$MRS/5.Combined_Analysis/combination/210803_final/

out=$script/out
if [ ! -d $out ] 
then
	mkdir -p $out
fi

AnalysisPath=$script/results/
if [ ! -d $AnalysisPath ];then
	mkdir -p $AnalysisPath
fi



########################################################################
##### filter enssemble features of concordant positions in call set ##### #########################
########################################################################

outfile=Ensemble_count.txt
rm -rf $AnalysisPath/$outfile
##### write column names of outfile
col="FEATURE,TYPE,TOTAL,COUNT,WHEN"
echo $col >> $AnalysisPath/col.txt
echo "`tr ',' '\t' <$AnalysisPath/col.txt`" >> $AnalysisPath/$outfile        
rm -rf $AnalysisPath/col.txt



PIPE_files=$(ls $script | egrep "2.pipe.*")
PIPE_LIST=(${PIPE_files// / })
for pipe in ${PIPE_LIST[*]};do
	echo $pipe	

	IFS='.' read -r -a arrTAG <<< "${pipe}"

	feature=${arrTAG[2]}
	if [[ $feature == "alt_softclip" ]];then

		infile=call_MT_raw_MF_mx_comparison.txt

	elif [[ $feature == "het_likelihood" ]];then
	
		infile=call_HC200_raw_MF_tp_comparison.txt
	else
		infile=call_HC200_raw_MT_mx_comparison.txt
	fi

	qsub -pe smp 1 -e $out -o $out -N $feature -hold_jid $feature \
	$script/$pipe \
	$script $AnalysisPath $infile $outfile 
	sleep 1
	
done


