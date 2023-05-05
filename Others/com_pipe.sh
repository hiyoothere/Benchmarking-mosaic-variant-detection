#!/bin/bash

## Key Variables
ROOT_DIR="/data/project/MRS"

TS_BAM_DIR="${ROOT_DIR}/2.Transplant/3.Merged_MRS"
DS_TS_BAM_DIR="${ROOT_DIR}/2.Transplant/5.downsample_Mosaic"
TS_BAM_TAIL="MRS.s.RGadd.LA.bam"
#TS_BAM_TAIL="preprocessed.bam"

NC_TS_BAM_DIR="${ROOT_DIR}/2.Transplant/3.Merged_MRS/1.whole_woClip"
NC_TS_BAM_TAIL="MRS.s.RGadd.LA.woClp.bam"

#MX_BAM_DIR="${ROOT_DIR}/1.Mixed/3.aligned_Mosaic/bwa_mem/1.whole"
MX_BAM_DIR="/data/project/MRS/ForSRA/All"
DS_MX_BAM_DIR="${ROOT_DIR}/1.Mixed/5.downsample_Mosaic"
#MX_BAM_TAIL="RF_il_WES.RGadded.marked.realigned.fixed.recal.LA.bam"
MX_BAM_TAIL="preprocessed.bam"

NC_BAM_DIR="/home/data/project/MRS/1.Mixed/3.aligned_Mosaic/bwa_mem/1.whole_woClip"
DS_NC_BAM_DIR="/home/data/project/MRS/1.Mixed/5.downsample_Mosaic/woClip"
NC_BAM_TAIL="_RF_il_WES.RGadded.marked.realigned.fixed.recal.LA.woClp.bam"
DS_NC_BAM_TAIL="LA.woClp.bam"

MX_LIB_BAM_DIR="/home/data/project/MRS/1.Mixed/3.aligned_Mosaic/bwa_mem"
MX_LIB_BAM_TAIL="_RF_il_WES.RGadded.marked.realigned.fixed.recal.LA.bam"

RS_BAM_DIR="${ROOT_DIR}/0.Genotype/3.aligned_Mosaic/bwa_mem"
RS_BAM_TAIL="RGadded.marked.realigned.fixed.recal.LA.bam"

TS_PUP_DIR="${ROOT_DIR}/4.Analysis_Mosaic/0.PU/0.DF/ts"
DS_TS_PUP_DIR="${ROOT_DIR}/4.Analysis_Mosaic/0.PU/2.DS/ts"

MX_PUP_DIR="${ROOT_DIR}/4.Analysis_Mosaic/0.PU/0.DF/mx"

RS_PUP_DIR="${ROOT_DIR}/4.Analysis_Mosaic/0.PU/0.DF/rs"

NC_PUP_DIR="${ROOT_DIR}/4.Analysis_Mosaic/0.PU/0.DF/nc"
DS_NC_PUP_DIR="${ROOT_DIR}/4.Analysis_Mosaic/0.PU/2.DS/nc"

ND_COM_PUP_DIR="${ROOT_DIR}/4.Analysis_Mosaic/0.PU/0.DF"
DS_COM_PUP_DIR="${ROOT_DIR}/4.Analysis_Mosaic/0.PU/2.DS"

ORD_CHR_LIST=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "X" "Y" "M")

## Function Collection
grab_ts_bam() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds != "ND" ]]; then
        ret+="${DS_TS_BAM_DIR}/${ds}.${input}.${TS_BAM_TAIL},"
    else
        ret+="${TS_BAM_DIR}/"SetB-"${input}.${TS_BAM_TAIL},"
    fi
    echo ${ret::-1}
}

grab_nc_ts_bam() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds != "ND" ]]; then
        ret+="${DS_NC_TS_BAM_DIR}/${ds}.${input}.${NC_TS_BAM_TAIL},"
    else
        ret+="${NC_TS_BAM_DIR}/${input}.${NC_TS_BAM_TAIL},"
    fi
    echo ${ret::-1}
}

cut_pair() {
    pair_input=$1
    field=$2
    ret=$(echo $pair_input | cut -d "_" -f $field)
    echo $ret
}

grab_pup() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds != "ND" ]]; then
        ret+="${DS_TS_PUP_DIR}/${ds}.${input}.pup,"
    else
        ret+="${TS_PUP_DIR}/${input}.pup,"
    fi
    echo ${ret::-1}
}

grab_iv_bam() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds == "ND" ]]; then
        ret+="${MX_BAM_DIR}/"SetA-"${input}.${MX_BAM_TAIL},"
    else
        ret+="${DS_MX_BAM_DIR}/${ds}.${input}.LA.bam,"
    fi
    echo ${ret::-1}
}

grab_mx_bam() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds == "ND" ]]; then
        ret+="${MX_BAM_DIR}/${input}_${MX_BAM_TAIL},"
    else
        ret+="${DS_MX_BAM_DIR}/${ds}.${input}.LA.bam,"
    fi
    echo ${ret::-1}
}

grab_mx_lib_bam() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds == "ND" ]]; then
        ret+="${MX_LIB_BAM_DIR}/1.whole/${input}${MX_LIB_BAM_TAIL},"
    elif [[ $ds == "D3" ]]; then
        ret+="${MX_LIB_BAM_DIR}/2.half/FP-${input}-A${MX_LIB_BAM_TAIL},"
    elif [[ $ds == "D2" ]]; then
        ret+="${MX_LIB_BAM_DIR}/3.single/FP-${input}-1${MX_LIB_BAM_TAIL},"
    fi
    echo ${ret::-1}
}

grab_iv_pup() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds == "ND" ]]; then
        ret+="${MX_PUP_DIR}/${input}.pup,"
    fi
    echo ${ret::-1}
}

grab_mx_pup() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds == "ND" ]]; then
        ret+="${MX_PUP_DIR}/${input}.pup,"
    fi
    echo ${ret::-1}
}

grab_rs_bam() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds == "ND" ]]; then
        ret+="${RS_BAM_DIR}/${input}.${RS_BAM_TAIL},"
    fi
    echo ${ret::-1}
}

grab_rs_pup() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds == "ND" ]]; then
        ret+="${RS_PUP_DIR}/${input}.pup,"
    fi
    echo ${ret::-1}
}

grab_nc_iv_bam() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds == "ND" ]]; then
        ret+="${NC_BAM_DIR}/${input}${NC_BAM_TAIL},"
    else
        ret+="${DS_NC_BAM_DIR}/${ds}.${input}.${DS_NC_BAM_TAIL},"
    fi
    echo ${ret::-1}
}

grab_nc_iv_pup() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds == "ND" ]]; then
        ret+="${NC_PUP_DIR}/${input}.pup,"
    else
        ret+="${DS_NC_PUP_DIR}/${ds}.${input}.pup,"
    fi
    echo ${ret::-1}
}

grab_nc_ts_pup() {
    input=$1
    ds=$2
    ret=""
    if [[ $ds == "ND" ]]; then
        ret+="${TS_PUP_DIR}/${input}.pup,"
    fi
    echo ${ret::-1}
}

grab_pup() {
    type=$1
    input=$2
    ds=$3
    if [[ $ds == "ND" ]]; then
        echo "${ND_COM_PUP_DIR}/${type}/${input}.pup"
    else
        echo "${DS_COM_PUP_DIR}/${type}/${ds}.${input}.pup"
    fi
}

grab_pup_by_chr() {
    type=$1
    input=$2
    ds=$3
    chrom=$4
    if [[ $ds == "ND" ]]; then
        echo "${ND_COM_PUP_DIR}/${type}/${input}/${input}.chr${chrom}.pup"
    else
        echo "${DS_COM_PUP_DIR}/${type}/${ds}.${input}/${ds}.${input}.chr${chrom}.pup"
    fi
}
