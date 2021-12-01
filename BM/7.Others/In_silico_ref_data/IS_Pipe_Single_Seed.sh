#!/bin/bash
#$ -cwd

source "/data/project/RefStand/gavehan/PIPE/Common_PIPE.sh"
source "/data/project/RefStand/gavehan/PIPE/Common_IS.sh"

## Input Parameters
REF=$1
INTERVAL=$2
INPUT=$3
DEP=$4
SEED=$5
OUT_DIR=$6

## Key Variables
ROOT_DIR="/data/project/RefStand"
PICARD_DIR="/opt/Yonsei/picard/2.2.2"
IV_PUP_DIR="${ROOT_DIR}/4.analysis_Mosaic/7.Varscan/pileup"
OPT_FILE="${ROOT_DIR}/4.analysis_Mosaic/10.IS_Mix/RS_Mix_Ratio2.txt"
RF_DEP=("1073.0983" "1241.4962" "1148.0805" "1162.1413" "936.8221" "931.9891")
PATH_LIST=("${OUT_DIR}/0-mix" "${OUT_DIR}/1-mix_qc" "${OUT_DIR}/2-cvcf" "${OUT_DIR}/3-analysis")
OUT_ID=$(CreateISFileID "${INPUT}" "${SEED}")

function GrabOptionFromFile() { 
  local input=$1
  mos_samp=$(ExtractMosSamp "${input}")
  ret=""
  while read opt_line; do
    IFS=$'\t'
    opt_e=($(echo "${opt_line}"))
    unset IFS
    if [[ ${opt_e[0]} == $mos_samp ]]; then
      ret="${opt_e[1]}"
      break
    fi
  done<"${OPT_FILE}"
  echo "${ret}"
}

## Mix
printf "\n%s\n" "*** Step 1: Donwnsampling"
mkdir -p "${PATH_LIST[0]}/${INPUT}-${SEED}"
opt=$(GrabOptionFromFile "${INPUT}")
IFS=$'_'
opt_arr=($(echo "${opt}"))
unset IFS
downsamp_check=1
for (( i = 0; i < ${#opt_arr[@]}; i++ )); do
  cur_opt="${opt_arr[$i]}"
  opt_check=$(echo "${cur_opt} > 0.0" | bc -l)
  if [[ $opt_check -eq 1 ]]; then
    (( i_alt = i + 1 ))
    InFile=$(GrabRFBam "${i_alt}")
    InFileId=$(echo "${InFile}" | cut -d "/" -f "8")
    printf "\n${InFile}\n"
    out_dep=$(echo "${DEP} * ${cur_opt}" | bc -l | python -c "print int(round(float(raw_input())))")
    out_p=$(echo "${out_dep} / ${RF_DEP[$i]}" | bc -l | python -c "print float(raw_input())")
    downsample_file="${InFileId::-4}.${out_dep}x.sd${SEED}.bam"
    test=$(ls "${PATH_LIST[0]}/${INPUT}-${SEED}" | grep "^${downsample_file}$")
    if [[ -z "$test" ]]; then
      downsamp_check=0
      printf "\nDownsampling RF-${i_alt} to target fraction of ${out_p} and target depth of ${out_dep} with seed ${SEED}\n"
      java -jar "${PICARD_DIR}/picard.jar" DownsampleSam \
      I="${InFile}" \
      O="${PATH_LIST[0]}/${INPUT}-${SEED}/${downsample_file}" \
      S="ConstantMemory" \
      P="${out_p}" \
      CREATE_INDEX="true" \
      R="${SEED}"
    else
      printf "RF-${i_alt} has been downsampled previously\n"
    fi
  fi
done
BamFile="${PATH_LIST[0]}/"
BamFile+=$(CreateIsBamName "${INPUT}" "${SEED}")
printf "\nAll donwnsampling complete\n"

printf "\n%s\n" "*** Step 2: .bam Post Processing"
if [[ $downsamp_check -gt 0 && -f "${BamFile}.bai" ]]; then
  printf "\n.bam has been post processed before\n"
else
  printf "\nMerging intermediate .bam files\n"
  samtools merge -1f "${BamFile::-4}.unsorted.bam" ${PATH_LIST[0]}/${INPUT}-${SEED}/*.bam
  printf "\nSorting merged .bam file\n"
  samtools sort -m "12G" -o "${BamFile}" "${BamFile::-4}.unsorted.bam"
  printf "\nIndexing merged .bam file\n"
  samtools index "${BamFile}"
fi
if [[ -f "${BamFile::-4}.unsorted.bam" ]]; then
  rm -f "${BamFile::-4}.unsorted.bam"
fi

printf "\n%s\n" "*** Step 3: Qualimap In Silico Sample"
if [[ -f "${PATH_LIST[1]}/${OUT_ID}/genome_results.txt" ]]; then
  printf "\n.bam has been quality checked before\n"
else
  qualimap bamqc --java-mem-size=12G -bam "${BamFile}" -gff "${INTERVAL}" -c -outdir "${PATH_LIST[1]}/${OUT_ID}"
fi

printf "\n%s\n" "*** Step 4: Create .pup File from In Silico Sample"
mkdir -p "${PATH_LIST[2]}/pileup"
PileupFile="${PATH_LIST[2]}/pileup/${OUT_ID}.pup"
if [[ -f "${PileupFile}" ]]; then
  printf "\n.pup has been created before\n"
else
  samtools mpileup -f "${REF}" -q "1" -Q "1" --ignore-RG --output "${PileupFile}" "${BamFile}"
fi

printf "\n%s\n" "*** Step 5: Create .cvcf File from IS and IV samples"
python3 -u "/data/project/RefStand/gavehan/PIPE/IS_Pipe_Parse_Pileup.py" \
"${PATH_LIST[2]}/pileup" "${PATH_LIST[2]}" "${OUT_ID}.pup" "${INPUT::-2}" "${IV_PUP_DIR}"

printf "\n%s\n" "*** Step 6: Create IS-IV Merged .txt File"
python3 -u "/data/project/RefStand/gavehan/PIPE/IS_Pipe_Merge_Files.py" \
"${PATH_LIST[2]}" "${PATH_LIST[2]}/merged" "${OUT_ID}" "${INPUT::-2}"