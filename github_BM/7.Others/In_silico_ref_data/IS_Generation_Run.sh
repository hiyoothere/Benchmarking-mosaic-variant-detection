#!/bin/bash
#$ -cwd

## Key Variables
source "/data/project/RefStand/gavehan/RUN/Common_RUN.sh"
DIR="/data/project/RefStand"
OUT_DIR="${DIR}/4.analysis_Mosaic/10.IS_Mix"
REF="/data/resource/reference/human/NCBI/GRCh38_GATK/BWAIndex/genome.fa"
INTERVAL="${DIR}/script/TargetRegion/k24.Target.exome.v5.sorted.merged.nochr5XY.sorted.6field.bed"
TARGET_DEP=1100
SEED_CNT=1

## Create Input
IFS=$'%'
Data=($(CreateWholeSingles "1.2.3" "w"))
unset IFS

for i in "${!Data[@]}"; do
	for (( j = 1; j <= $SEED_CNT; j++ )); do
		## Mix
		qsub -j "y" -o "${DIR}/gavehan/LOG_IS" \
		-hold_jid "None" -N "i-${Data[$i]::-2}.${j}.${TARGET_DEP}" \
		"${DIR}/gavehan/PIPE/IS_Pipe_Single_Seed.sh" \
		"${REF}" "${INTERVAL}" "${Data[$i]}" "${TARGET_DEP}" "${j}" "${OUT_DIR}"
		sleep "15"
	done
done
