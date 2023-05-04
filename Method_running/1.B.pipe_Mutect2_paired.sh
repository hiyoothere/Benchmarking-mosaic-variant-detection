#!/bin/bash
#$ -cwd

REF=$1
DataPath=$2
ID_cas=$3
ID_con=$4
INTERVAL=$5
AnalysisPath=$6


gatk Mutect2 \
-R $REF \
-I $DataPath$ID_cas'.bam' \
-I $DataPath$ID_con'.bam' \
--tumor $ID_cas \
--normal $ID_con \
-L $INTERVAL \
-O $AnalysisPath$ID_cas'_'$ID_con'.vcf'
#
gatk FilterMutectCalls \
-R $REF \
-V $AnalysisPath$ID_cas'_'$ID_con'.vcf'  \
-O $AnalysisPath$ID_cas'_'$ID_con'.filtered.vcf'

# Collect variants annotated as normal artifact without any other filters for shared variant detection
cat $AnalysisPath$ID_cas'_'$ID_con'.filtered.vcf' | egrep "PASS|normal_artifact" | egrep -v "normal_artifact;"| egrep -v ";normal_artifact" > $AnalysisPath$ID_cas'_'$ID_con'.filtered.Share.PASS.vcf'
