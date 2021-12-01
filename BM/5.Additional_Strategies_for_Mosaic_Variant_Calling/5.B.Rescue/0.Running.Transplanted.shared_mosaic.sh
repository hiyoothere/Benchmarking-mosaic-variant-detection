#!/bin/bash
#$ -cwd



## mandatory argument
# 1. project name
PROJECT=MRS
DIR=/data/project/MRS
HOME=/home/jkim1105

# 5. data dir
NDPath=$DIR/2.Transplant/3.Merged_MRS
DSPath=$DIR/2.Transplant/5.downsample_Mosaic

MSM=$DIR/4.Analysis_Mosaic/13.MSM
script=../5.B.Rescue
depth=../../1.Pipelines_For_Running_Tools/1.B.pipe_M2S2MH

out=$script/out/tp

if [ ! -d $out ]
then
        mkdir -p -m 770 $out
fi

PICARD=/opt/Yonsei/Picard/2.23.1



DP_ID=("ND" "D1" "D2" "D3")


M_CASE="M3"
M_CTRL="M1|M2"

Mutant=("snv" "ind")


for idx_DP in ${!DP_ID[@]};do
	DP=${DP_ID[idx_DP]}
	echo $DP
	#### case sample name list
	if [[ $DP == *"ND"* ]];then
		CASE_BAM=$(ls $NDPath  | egrep ".bam" | egrep -v "bai" |  egrep  $M_CASE )
		path_tag_arr=("1.DF_A" "7.IND_A")
		PU=$DIR/4.Analysis_Mosaic/0.PU/1.DF_A/parse_ts_wc2/0.by_var_type ## MUST BE WITHOUT CLIP (version 2)
		DEPTH=$depth/depth.5.95.txt ### set B used for depth calculation
	else
		CASE_BAM=$(ls $DSPath  | egrep "${DP}" | egrep ".bam" | egrep -v "bai" |  egrep  $M_CASE )
		path_tag_arr=("3.DS_A" "8.IND_DS")
		DEPTH=$depth/depth.5.95.${DP}.txt ### set B used for depth calculation
		PU=$DIR/4.Analysis_Mosaic/0.PU/3.DS_A/parse_ts_wc/0.by_var_type ## MUST BE WITHOUT CLIP (version 2)
	fi
	CASE_LIST=(${CASE_BAM// / })
	
	### loop through to get CTRL	
	for idx in ${!CASE_LIST[@]};do
		if [[ $DP == *"ND"* ]];then
			CTRL_BAM=$(ls $NDPath  | egrep ".bam" | egrep -v "bai" | egrep $M_CTRL )
			ID_cas=${CASE_LIST[idx]%%_RF_il_WES.RGadded.marked.realigned.fixed.recal.LA.bam*}
		else	
			CTRL_BAM=$(ls $DSPath  | egrep "${DP}" | egrep ".bam" | egrep -v "bai" | egrep $M_CTRL )
			ID_cas=${CASE_LIST[idx]%%.LA.bam*}
		fi
		CTRL_LIST=(${CTRL_BAM// / })
		
		### loop through CASE_CTRL for running
		for idx in ${!CTRL_LIST[@]};do
			
			if [[ $DP == *"ND"* ]];then
                                ID_con=${CTRL_LIST[idx]%%_RF_il_WES.RGadded.marked.realigned.fixed.recal.LA.bam*}
                        else
                                ID_con=${CTRL_LIST[idx]%%.LA.bam*}
                        fi

			ID="tp.${ID_cas}_${ID_con}"
			echo $ID

			####### loop if snv or ind
			for mut in ${Mutant[*]};do
				echo $mut
				if [[ $mut == "snv" ]];then
					path_tag=${path_tag_arr[0]}	
					TOOL=("3.MF" "14.DM")
				elif [[ $mut == "ind" ]];then
					path_tag=${path_tag_arr[1]}
					TOOL=("3.MF")
				fi
				for tool_n in ${TOOL[*]};do

					IFS='.' read -r -a arrTool <<< "${tool_n}"	
					tool=${arrTool[1]}
					echo $tool
					
					######## OUTPUT location ##################################################
					#FINAL=$DIR/Figure/5b/$tool_n
					FINAL=$script/results/$tool_n ##### output at script directory

					###### STEP 1: shared calls in CASE and CTRL 
					log=$out/$tool_n/1.conc/$path_tag
                        	        if [ ! -d $log ];then
                        	                mkdir -p $log
                        	        fi

					DataPath=$DIR/4.Analysis_Mosaic/$tool_n/$path_tag/tp
					STEP1=$FINAL/interim/1.conc/$path_tag/tp
		        	        qsub -e $log -o $log -N $tool'_conc.'$ID \
					-hold_jid $tool'_conc.'$ID \
				        $script/1.pipe.MH_conc.sh \
		        	        $ID_con $ID_cas $DataPath $STEP1 $script $DP
		        	        sleep 1	
					
					#### STEP 2: alt rescue
					#### ctrl_case_specific
					#### case_ctrl_specific
					#### ctrl_case.sha
					log=$out/$tool_n/2.rescue_alt3/$path_tag
                        	        if [ ! -d $log ];then
                        	                mkdir -p $log
                        	        fi

		        	       	STEP2=$FINAL/interim/2.rescue_alt3/$path_tag/tp
		        	        qsub -e $log -o $log -N $tool'_rescue_alt3.'$ID \
					-hold_jid $tool'_rescue_alt3.'$ID,$tool'_conc.'$ID \
		        	        $script/2.pipe.MH_sort_alt3.sh \
		        	        $ID_con $ID_cas $STEP1 $PU $STEP2 $script $DP
		        	        sleep 1
					
					### STEP 3: final call set with data
					### when shared from
					log=$out/$tool_n/3.extract_data/$path_tag
					if [ ! -d $log ];then
                        	                mkdir -p $log
                        	        fi
					
					DATA=$DIR/4.Analysis_Mosaic/$tool_n/$path_tag/tp
					STEP3=$FINAL/interim/3.extract_data/$path_tag/tp
		        	        qsub -e $log -o $log -N $tool'_add_data.'$ID \
					-hold_jid $tool'_rescue_alt3.'$ID,$tool'_conc.'$ID,$tool'_add_data.'$ID \
		        	        $script/3.pipe.MH_final.sh \
		        	        $ID_con $ID_cas $STEP2 $DATA $STEP3 $script
		        	        sleep 1
					

					###### STEP 4: depth filter (132 <  < 1472)
					log=$out/$tool_n/4.depth_filter/$path_tag
					if [ ! -d $log ];then
						mkdir -p $log
					fi

					DM_DP=$DIR/Resource/DM_running/input
					STEP4=$FINAL/$path_tag/tp
					qsub -e $log -o $log -N $tool"_depth_filter."$ID \
					-hold_jid $tool'_conc.'$ID,$tool'_rescue_alt3.'$ID,$tool'_add_data.'$ID,$tool"_depth_filter."$ID \
					$script/4.pipe.MH_depth.sh \
					$ID_con $ID_cas $STEP3 $STEP4 $DEPTH $script $DM_DP
					sleep 1
					
					###### STEP 5: add total
					log=$out/$tool_n/total/$path_tag
                        	        if [ ! -d $log ];then
                        	                mkdir -p $log
                        	        fi

	                		qsub -e $log -o $log -N $tool'_total.'$ID \
					-hold_jid $tool'_conc.'$ID,$tool'_rescue_alt3.'$ID,$tool'_add_data.'$ID,$tool"_depth_filter."$ID,$tool'_total.'$ID \
		        	        $script/5.pipe.total.sh \
	        		        $ID_con $ID_cas $STEP4
	                		sleep 1
					
				done
			done
		done
	done
done

