#!/bin/bash
#$ -cwd

REF=$1
DataPath=$2
ID=$3
INTERVAL=$4
AnalysisPath=$5

M_TYPE=$(echo $ID | awk -F - '{ print $1 }')
PON=/data/project/MRS/Resource/PoN/1000g_pon.hg38.$M_TYPE'.rem.vcf.gz'

#1.1 Mutect2
gatk Mutect2 \
-R $REF \
-I $DataPath/$ID'_RF_il_WES.RGadded.marked.realigned.fixed.recal.LA.bam' \
-L $INTERVAL \
--panel-of-normals $PON \
--do-not-run-physical-phasing \
-O $AnalysisPath$ID'.vcf'

#1.2 Filter
gatk FilterMutectCalls \
-R $REF \
-V $AnalysisPath$ID'.vcf'  \
-O $AnalysisPath$ID'.filtered.vcf'

cat $AnalysisPath$ID'.filtered.vcf' | egrep "PASS|#" > $AnalysisPath$ID'.filtered.PASS.vcf'

