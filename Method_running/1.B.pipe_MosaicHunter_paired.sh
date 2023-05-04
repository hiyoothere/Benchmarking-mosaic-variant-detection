#!/bin/bash

source "/home/gavehan/WORKSPACE/common/com_pipe.sh"
# source "/home/data/project/MRS/gv_workspace/com_pipe.sh"

## Input Parameters

REF_FA=$1
case_bam=$2
ctrl_bam=$3
OUT_DIR=$4
case_id=$5
MH_DIR=$6

## Common Variables
IN_MOS=$(echo "${case_id}" | cut -d "-" -f "1")

# SCRIPT_DIR="/home/data/project/MRS/gv_workspace"
RES_DIR="/data/project/MRS/Resource/MH" #other resources to run MosaicHunter
REP_REG="$MH_DIR}/rep_reg/region_sRepeat_segdup.201026.s.m.pad.bed"
IND_REG="${RES_DIR}/ind_reg/${IN_SAMP}.Haplotype.filtered_snps.indels.PASS.MQR.SOR.5pad.s.merge.bed" #germline indels from HaplotypeCaller and 5bp flanking regions per sample
COM_REG="$MH_DIR/WES_Agilent_71M.error_prone.Liftover.hg38.bed"
SNP_DB="dbSNP.b154.GRCh38.${IN_MOS}.rem.vcf" # Positive controls were removed from dbsnp for running

out_dir="${OUT_DIR}/${IN_TYPE}/${IN_DS}-${in_case}/${in_ctrl}"
mkdir -p $out_dir

# # 1. Exome Parameters
 echo "###"
 echo "### Exome Parameters"
 echo "###"
 java -Xmx${MEM_SIZE}G -jar "${RES_DIR}/MosaicHunter/build/mosaichunter.jar" \
 -C "${RES_DIR}/exome_parameters.properties" \
 -P input_file=$case_bam \
 -P reference_file=$REF_FA \
 -P output_dir="${out_dir}/param" \
 -P repetitive_region_filter.bed_file=$REP_REG \
 -P indel_region_filter.bed_file=$IND_REG \
 -P common_site_filter.bed_file=$COM_REG \
 -P mosaic_filter.dbsnp_file=$SNP_DB

# 2. Grab alpha-beta
param_str=$(python3 "./MH_Grab_Exome_Param.py" "${IN_SAMP}" "${IN_DS}" "${out_dir}/param/")
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
