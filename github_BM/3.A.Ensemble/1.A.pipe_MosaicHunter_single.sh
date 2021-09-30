#!/bin/bash

source "/home/gavehan/WORKSPACE/common/com_pipe.sh"
# source "/home/data/project/MRS/gv_workspace/com_pipe.sh"

## Input Parameters
IN_SAMP=$1
IN_DS=$2
IN_TYPE=$3
REF_FA=$4
OUT_DIR=$5
JOB_BUNDLE=$6

## Common Variables
IN_MOS=$(echo "${IN_SAMP}" | cut -d "-" -f "1")
SCRIPT_DIR="/home/gavehan/WORKSPACE"
# SCRIPT_DIR="/home/data/project/MRS/gv_workspace"
RES_DIR="/data/project/MRS/Resource/MH"
REP_REG="${RES_DIR}/rep_reg/region_sRepeat_segdup.201026.s.m.pad.bed"
IND_REG="${RES_DIR}/ind_reg/${IN_SAMP}.Haplotype.filtered_snps.indels.PASS.MQR.SOR.5pad.s.merge.bed"
COM_REG="${RES_DIR}/com_reg/WES_Agilent_71M.error_prone.Liftover.hg38.bed"
# SNP_DB="${RES_DIR}/db_snp/dbSNP.b154.GRCh38.${IN_MOS}.rem.vcf"
SNP_DB="/data/public/dbSNP/b154/GRCh38/GCF_000001405.38.re.vcf"
MEM_SIZE=$(echo "${JOB_BUNDLE} * 10" | bc -l)

## Translate Input
if [[ $IN_TYPE =~ ts* ]]; then
    in_bam=$(grab_ts_bam "$IN_SAMP" "$IN_DS")
elif [[ $IN_TYPE =~ rs* ]]; then
    in_bam=$(grab_rs_bam "$IN_SAMP" "$IN_DS")
else
    in_bam=$(grab_mx_bam "$IN_SAMP" "$IN_DS")
fi
out_dir="${OUT_DIR}/${IN_TYPE}/${IN_DS}-${IN_SAMP}"
mkdir -p "${out_dir}/param"

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
param_str=$(python3 "${SCRIPT_DIR}/pipe/MH_Grab_Exome_Param.py" "${IN_SAMP}" "${IN_DS}")
echo "$param_str"
# read -a param_arr < <(echo $param_str | tr ';' ' ')

# 3. Single Mode
# echo "###"
# echo "### Exome Single"
# echo "###"
# java -Xmx${MEM_SIZE}G -Xms${MEM_SIZE}G -XX:ActiveProcessorCount=4 \
# -jar "${RES_DIR}/MosaicHunter/build/mosaichunter.jar" \
# -C "${RES_DIR}/exome.properties" \
# -P input_file=$in_bam \
# -P reference_file=$REF_FA \
# -P output_dir=$out_dir \
# -P mosaic_filter.alpha_param="${param_arr[1]}" \
# -P mosaic_filter.beta_param="${param_arr[2]}" \
# -P repetitive_region_filter.bed_file=$REP_REG \
# -P common_site_filter.bed_file=$COM_REG \
# -P mosaic_filter.dbsnp_file=$SNP_DB \
# -P indel_region_filter.bed_file=$IND_REG \
# -P misaligned_reads_filter.reference_file=$REF_FA \
# -P misaligned_reads_filter.blat_param="-stepSize=5 -repMatch=2253 -minScore=0 -minIdentity=50 -noHead" \
# -P syscall_filter.depth="${param_arr[0]}" \

