#!/bin/bash
#$ -cwd



## mandatory argument
# 1. project name
PROJECT=MRS
DIR=/data/project/MRS

# 2. read data type
TYPE=TR

# 3. sequencing platform

PLATFORM=il

# 4. reference path
REF=/data/resource/reference/human/NCBI/GRCh38_GATK/BWAIndex/genome.fa
# 5. data dir
NDPath=$DIR/2.Transplant/3.Merged_MRS
DSPath=$DIR/2.Transplant/5.downsample_Mosaic

INTERVAL=$DIR/script/TargetRegion/SureSelect_v5.hg38.new.bed
GENEFILE=$DIR/script/hg38_WGS.wo_cont.sorted.refGene
OPT='_'$PROJECT'_'$PLATFORM'_'$TYPE
dbSNP=/data/public/dbSNP/b153/GRCh38/GCF_000001405.38.re.vcf.gz


MSM=$DIR/4.Analysis_Mosaic/13.MSM
script=/home/jkim1105/jisoo_backup/3.BM_MSM


if [ ! -d $DIR/out/tp ]
then
        mkdir -p -m 770 $DIR/out/tp
fi

PICARD=/opt/Yonsei/Picard/2.23.1

DP_ID=("ND" "D1" "D2" "D3")

MSM=$DIR/4.Analysis_Mosaic/13.MSM
M_CASE="M3"
M_CTRL="M1|M2"

log=$DIR/out/tp/MSM/

for idx_DP in ${!DP_ID[@]};do
	DP=${DP_ID[idx_DP]}
	echo $DP
	#### NORMAL - TUMOR ################################################################
	#### case sample name list
	if [[ $DP == *"ND"* ]];then
		path_tag=0.DF
		CASE_BAM=$(ls $NDPath  | egrep ".bam" | egrep -v "bai" |  egrep  $M_CASE )
		DataPath=$NDPath
		PU=/data/project/MRS/4.Analysis_Mosaic/0.PU/1.DF_A/parse_ts_wc2/0.by_var_type
		DEPTH=$script/depth/depth.5.95.txt ####### NEEDS TO BE TRANSPLANTED
	else
		path_tag=2.DS
		CASE_BAM=$(ls $DSPath  | egrep "${DP}" | egrep ".bam" | egrep -v "bai" |  egrep  $M_CASE)
		DataPath=$DSPath
		PU=/data/project/MRS/4.Analysis_Mosaic/0.PU/3.DS_A/parse_ts_wc/0.by_var_type
		DEPTH=$script/depth/depth.5.95.${DP}.txt ####### NEEDS TO BE TRANSPLANTED
	fi
	CASE_LIST=(${CASE_BAM// / })
	
	### loop through to get CTRL	
	for idx in ${!CASE_LIST[@]};do
		if [[ $DP == *"ND"* ]];then
			ID_cas=${CASE_LIST[idx]%%.MRS.s.RGadd.LA.bam*}
			CTRL_BAM=$(ls $NDPath  | egrep ".bam" | egrep -v "bai" | egrep $M_CTRL )
		else
			ID_cas=${CASE_LIST[idx]%%.MRS.s.RGadd.LA.bam*}	
			CTRL_BAM=$(ls $DSPath  | egrep "${DP}" | egrep ".bam" | egrep -v "bai" | egrep $M_CTRL )
		fi
		CTRL_LIST=(${CTRL_BAM// / })
		
		### loop through CASE_CTRL for running
		for idx in ${!CTRL_LIST[@]};do
			if [[ $DP == *"ND"* ]];then
				ID_con=${CTRL_LIST[idx]%%.MRS.s.RGadd.LA.bam*}
			else
				ID_con=${CTRL_LIST[idx]%%.MRS.s.RGadd.LA.bam*}
			fi
			ID="tp.${ID_cas}_${ID_con}"
			echo $ID
			echo $path_tag	
			### RAW BAM 
			# Mutect2 + Strelka2
		
			#### step 1 : Manta Running:
			#AnalysisPath=$MSM/jkim_workspace/0.Manta/$path_tag/tp	
			#qsub -e $log/0.Manta/$path_tag -o $log/0.Manta/$path_tag -pe smp 1 -hold_jid 'manta.'$ID -N 'manta.'$ID \
	                #$script/pipe.manta.sh \
	                #$REF $DataPath $ID_con $ID_cas $INTERVAL $AnalysisPath $DS
	                #sleep 50
			#
			##### step 2 :  STK running
			#AnalysisPath=$MSM/jkim_workspace/1.STK/$path_tag/tp
			#MantaPath=$MSM/jkim_workspace/0.Manta/$path_tag/tp
			#qsub -e $log/1.STK/$path_tag -o $log/1.STK/$path_tag -pe smp 1 -N 'stk2.'$ID \
			#-hold_jid 'manta.'$ID,'stk2.'$ID \
			#$script/pipe.strelka2.NEW.sh \
	                #$REF $DataPath $ID_con $ID_cas $INTERVAL $AnalysisPath $MantaPath $DP
			#sleep 50
	
			##### step 3: STK - PASS running
			#AnalysisPath=$MSM/jkim_workspace/1.STK/$path_tag/tp
		        #qsub -e $log/1.0.STK_PASS/$path_tag -o $log/1.0.STK_PASS/$path_tag -N 'PASS.stk2.'$ID \
			#-hold_jid 'manta.'$ID,'stk2.'$ID,'PASS.stk2.'$ID \
			#$script/pipe.PASS_filter.sh \
		       	#$ID_con $ID_cas $AnalysisPath 
	        	#sleep 1
		
			#### step 4: MT_STK concurremt calls
			#STKpath=$MSM/jkim_workspace/1.STK/$path_tag/tp
			#MTpath=$DIR/4.Analysis_Mosaic/5.MT_P/$path_tag/tp
			#AnalysisPath=$MSM/jkim_workspace/2.MT-STK/$path_tag/tp
			#qsub -e $log/2.MT_STK/$path_tag -o $log/2.MT_STK/$path_tag -N 'MS.'${ID} \
			#-hold_jid 'PASS.stk2.'$ID,'MS.'${ID} \
			#$script/pipe.STK_MT.conc.sh \
			#$ID_con $ID_cas $AnalysisPath $STKpath $MTpath $script
			#sleep 1
	
			#### step 5: MT_STK segdup repeat filter
			#DataPath=$MSM/jkim_workspace/2.MT-STK/$path_tag/tp
			#AnalysisPath=$MSM/jkim_workspace/3.MT_STK.filter_rep/$path_tag/tp
			#qsub -e $log/3.MT_STK.filter_rep/$path_tag -o $log/3.MT_STK.filter_rep/$path_tag  -N 'MS.rep_rem.'${ID} \
			#-hold_jid 'PASS.stk2.'$ID,'MS.rep_rem.'${ID},'MS.'${ID} \
	                #$script/script.STK_MT.repeat_filter.sh \
	                #$ID_con $ID_cas $DataPath $AnalysisPath
	                #sleep 1	
			
			#### step 6: MT_STK 5bp gerline indel filter
			#DataPath=$MSM/jkim_workspace/3.MT_STK.filter_rep/$path_tag/tp
			#FILTER=$DIR/2.Transplant/4.Analysis_Mosaic/HC2/1.DF_A/MH_Indel
			#AnalysisPath=$MSM/jkim_workspace/4.MT_STK.filter_germIND/$path_tag/tp
			#qsub -e $log/4.MT_STK.filter_germIND/$path_tag -o $log/4.MT_STK.filter_germIND/$path_tag -N 'MS.rep_germIND.'${ID} \
			#-hold_jid 'PASS.stk2.'$ID,'MS.'${ID},'MS.rep_rem.'${ID},'MS.rep_germIND.'${ID} \
			#$script/script.STK_MT.germINDEL.sh \
	                #$ID_con $ID_cas $DataPath $AnalysisPath $FILTER $script
	                #sleep 2
			
				
			#########################################################################################
			## MosaicHunter 
			#########################################################################################

			#### step 1: shared calls in MH case control 
			#MH=$DIR/4.Analysis_Mosaic/1.MH/$path_tag/tp
			#AnalysisPath=$MSM/jkim_workspace/5.MH_S.merge/$path_tag/tp
	                #qsub -e $log/5.MH_S.merge/$path_tag -o $log/5.MH_S.merge/$path_tag -N 'MH_conc.'${ID} \
			#-hold_jid 'MH_conc.'${ID} \
	                #$script/pipe.MH_conc.sh \
	                #$ID_con $ID_cas $MH $AnalysisPath $script $DP
	                #sleep 1		
			#
			#### step 2: ALT 3 rescue : tissue specific -- > shared variants
			#### expected output:
			#### ctrl_case_specific
			#### ctrl_case.sha
			#POS=$MSM/jkim_workspace/5.MH_S.merge/$path_tag/tp
	                #AnalysisPath=$MSM/jkim_workspace/6.MH_S.filter_alt3/$path_tag/tp
	                #qsub -e $log/6.MH_S.filter_alt3/$path_tag -o $log/6.MH_S.filter_alt3/$path_tag  -N 'MH_sort_alt3.'${ID} \
			#-hold_jid 'MH_conc.'${ID},'MH_sort_alt3.'${ID} \
	                #$script/pipe.MH_sort_alt3.sh \
	                #$ID_con $ID_cas $POS $PU $AnalysisPath $script $DP
	                #sleep 1
			#
			#### step 3: final call set with data
			#### when shared from
			#POS=$MSM/jkim_workspace/6.MH_S.filter_alt3/$path_tag/tp 
			#DATA=$DIR/4.Analysis_Mosaic/1.MH/$path_tag/tp
			#AnalysisPath=$MSM/jkim_workspace/7.MH_S.final/$path_tag/tp
	                #qsub -e $log/7.MH_S.final/$path_tag -o $log/7.MH_S.final/$path_tag -N 'MH_final.'${ID} \
			#-hold_jid 'MH_conc.'${ID},'MH_sort_alt3.'${ID},'MH_final.'${ID} \
	                #$script/pipe.MH_final.sh \
	                #$ID_con $ID_cas $POS $DATA $AnalysisPath $script
	                #sleep 1
			#
			### step 3: final call set with data
	                ### when shared from
	               	DataPath=$MSM/jkim_workspace/7.MH_S.final/$path_tag/tp
	               	AnalysisPath=$MSM/jkim_workspace/8.MH_S.final.filter_depth/$path_tag/tp
	                qsub -e $log/8.MH_S.final.filter_depth/$path_tag -o $log/8.MH_S.final.filter_depth/$path_tag -N 'MH_depth.'${ID} \
			-hold_jid 'MH_conc.'${ID},'MH_sort_alt3.'${ID},'MH_final.'${ID},'MH_depth.'${ID} \
	                $script/pipe.MH_depth.sh \
	                $ID_con $ID_cas $DataPath $AnalysisPath $DEPTH $script
	                sleep 1
	
	                ### FINAL : merge MS and MH
	                MS=$MSM/jkim_workspace/4.MT_STK.filter_germIND/$path_tag/tp
	                MH=$MSM/jkim_workspace/8.MH_S.final.filter_depth/$path_tag/tp
	                AnalysisPath=$MSM/$path_tag/tp
	                qsub -e $log/final/$path_tag -o $log/final/$path_tag -N 'FINAL_MSM.'${ID} \
			-hold_jid 'FINAL_MSM.'${ID},'MS.'${ID},'MS.rep_rem.'${ID},'MS.rep_germIND.'${ID},'MH_conc.'${ID},'MH_sort_alt3.'${ID},'MH_final.'${ID},'MH_depth.'${ID} \
	                $script/pipe.FINAL_MSM.sh \
	                $ID_con $ID_cas $MS $MH $AnalysisPath $script
	                sleep 1
			
			DataPath=$MSM/$path_tag/tp
                        qsub -e $log/total/$path_tag -o $log/total/$path_tag -N 'total.'${ID} \
			-hold_jid 'total.'${ID},'FINAL_MSM.'${ID},'MS.'${ID},'MS.rep_rem.'${ID},'MS.rep_germIND.'${ID},'MH_conc.'${ID},'MH_sort_alt3.'${ID},'MH_final.'${ID},'MH_depth.'${ID} \
                        $script/pipe.total.sh \
                        $ID_con $ID_cas $DataPath
                        sleep 1
		done
	done


done


##### DEPTH 5, 95th percentile
#DataPath=/data/project/MRS/4.Analysis_Mosaic/GATK/VCF/tp/
#BED=/data/project/MRS/script/TargetRegion/SureSelect_v5.hg38.new.bed
#AnalysisPath=/data/project/MRS/4.Analysis_Mosaic/13.MSM/interim/tp
#outfile=$AnalysisPath/depth.5.95.txt
#qsub -pe smp 5 -e $DIR/out/tp/ -o $DIR/out/tp/ -N 'depth_interval' $DIR/script/MSM/pipe.depth_interval.sh \
#$AnalysisPath $outfile $DIR/script/MSM $DataPath $BED
#sleep 1
