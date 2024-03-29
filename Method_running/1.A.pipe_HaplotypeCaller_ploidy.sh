#!/bin/bash
#$ -cwd

REF=$1
AlignedPath=$2
AnalysisPath=$3
INPUT=$4
ID=${INPUT%%.bam*}
Ploidy=$5


# 1. Variant call by GATK 
gatk --java-options "-Xmx16g" HaplotypeCaller \
-R $REF \
-I $AlignedPath$INPUT \
-O $AnalysisPath$ID.Haplotype.Ploidy20.raw.snps.vcf \
--sample-ploidy $Ploidy \ #ploidy option for 20 and 200 in this study

#2. quality filter
-R $REF \
-V $DataPath$ID.raw.snps.vcf \
-O $DataPath$ID.filtered_snps.vcf \
--filter-name "QD" \
--filter-expression "QD < 2.0" \
--filter-name "FS" \
--filter-expression "FS > 60.0" \
--filter-name "LowCoverage" \
--filter-expression "DP < 20 " \
--filter-name "MQ" \
--filter-expression "MQ < 40.0" \
--filter-name "ReadPosRankSum" \
--filter-expression  "ReadPosRankSum < -8.0" \
--filter-name "MappingQualRanksum" \
--filter-expression "MappingQualityRankSum < -2.5 || MappingQualityRankSum > 2.5"
