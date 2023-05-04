#!/bin/bash
#$ -cwd

REF=$1
DataPath=$2
AnalysisPath=$3
INPUT=$4
ID=$5

M_TYPE=$(echo $ID | awk -F - '{ print $1 }')
PON=/data/project/MRS/Resource/PoN/1000g_pon.hg38.$M_TYPE'.rem.vcf.gz' #Remove positive controls from Panel of normal for running

#1.1 Mutect2
gatk Mutect2 \
-R $REF \
-I $DataPath/$INPUT \
--panel-of-normals $PON \
--do-not-run-physical-phasing \
-O $AnalysisPath$ID'.vcf'

#1.2 Filter
gatk FilterMutectCalls \
-R $REF \
-V $AnalysisPath$ID'.vcf'  \
-O $AnalysisPath$ID'.filtered.vcf'

cat $AnalysisPath$ID'.filtered.vcf' | egrep "PASS|#" > $AnalysisPath$ID'.filtered.PASS.vcf'

