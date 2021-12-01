#!/bin/bash

source "/home/gavehan/WORKSPACE/common/com_pipe.sh"
# source "/home/data/project/MRS/gv_workspace/com_pipe.sh"

## Input Parameters
IN_PAIR=$1
IN_DS=$2
IN_TYPE=$3
REF_FA=$4
OUT_DIR=$5
JOB_BUNDLE=$6

## Common Variables
IN_MOS=$(echo "${IN_PAIR}" | cut -d "-" -f "1")
in_case=$(cut_pair $IN_PAIR "1")
in_ctrl=$(cut_pair $IN_PAIR "2")
SCRIPT_DIR="/home/gavehan/WORKSPACE"
# SCRIPT_DIR="/home/data/project/MRS/gv_workspace"
RES_DIR="/data/project/MRS/Resource/MH"
REP_REG="${RES_DIR}/rep_reg/region_sRepeat_segdup.201026.s.m.pad.bed"
IND_REG="${RES_DIR}/ind_reg/ND.${in_case}.HC.Ploidy2.fil.ind.5pad.s.merge.bed"
COM_REG="${RES_DIR}/com_reg/WES_Agilent_71M.error_prone.Liftover.hg38.bed"
SNP_DB="${RES_DIR}/db_snp/dbSNP.b154.GRCh38.${IN_MOS}.rem.vcf"
MEM_SIZE=$(echo "${JOB_BUNDLE} * 9" | bc -l)

## Translate Input
if [[ $IN_TYPE =~ ts* ]]; then
    case_bam=$(grab_ts_bam "$in_case" "$IN_DS")
    ctrl_bam=$(grab_ts_bam "$in_ctrl" "$IN_DS")
    TARGET_REG="${RES_DIR}/is_ts_target_reg/${IN_MOS}.pc.all.clean.germline.merged.sorted.block.bed"
else
    case_bam=$(grab_mx_bam "$in_case" "$IN_DS")
    ctrl_bam=$(grab_mx_bam "$in_ctrl" "$IN_DS")
    TARGET_REG="${RES_DIR}/iv_mx_target_reg/${IN_MOS}.pc.all.clean.refhom.merged.sorted.block.bed"
fi
out_dir="${OUT_DIR}/${IN_TYPE}/${IN_DS}-${in_case}/${in_ctrl}"
mkdir -p $out_dir

# # 1. Exome Parameters
 echo "###"
 echo "### Exome Parameters"
 echo "###"
 java -Xmx${MEM_SIZE}G -jar "${RES_DIR}/MosaicHunter/build/mosaichunter.jar" \
 -C "${RES_DIR}/exome_parameters.properties" \
 -P input_file=$in_bam \
 -P reference_file=$REF_FA \
 -P output_dir="${out_dir}/param" \
 -P repetitive_region_filter.bed_file=$REP_REG \
 -P indel_region_filter.bed_file=$IND_REG \
 -P common_site_filter.bed_file=$COM_REG \
 -P mosaic_filter.dbsnp_file=$SNP_DB

# 2. Grab alpha-beta
param_str=$(python3 "${SCRIPT_DIR}/pipe/MH_Grab_Exome_Param.py" "${in_case}" "${IN_DS}")
echo "$param_str"
read -a param_arr < <(echo $param_str | tr ';' ' ')

# 3. Single Mode
echo "###"
echo "### Exome Paired"
echo "###"
java -Xmx${MEM_SIZE}G -Xms${MEM_SIZE}G -XX:ActiveProcessorCount=4 \
-jar "${RES_DIR}/MosaicHunter/build/mosaichunter.jar" \
-C "${RES_DIR}/exome.properties" \
-P input_file=$case_bam \
-P reference_file=$REF_FA \
-P output_dir=$out_dir \
-P mosaic_filter.alpha_param="${param_arr[1]}" \
-P mosaic_filter.beta_param="${param_arr[2]}" \
-P repetitive_region_filter.bed_file=$REP_REG \
-P common_site_filter.bed_file=$COM_REG \
-P mosaic_filter.dbsnp_file=$SNP_DB \
-P indel_region_filter.bed_file=$IND_REG \
-P misaligned_reads_filter.reference_file=$REF_FA \
-P misaligned_reads_filter.blat_param="-stepSize=5 -repMatch=2253 -minScore=0 -minIdentity=50 -noHead" \
-P syscall_filter.depth="${param_arr[0]}" \
-P mosaic_filter.mode="paired_naive" \
-P mosaic_filter.control_bam_file=$ctrl_bam \
-P target_site_filter.bed_file="${TARGET_REG}"
