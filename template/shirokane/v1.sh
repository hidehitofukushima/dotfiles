# ============================================================
# version and project name specification
# ============================================================

#$ -S /usr/bin/bash
#$ -cwd
#$ -o log/
#$ -e log/
#$ -l s_vmem=1G
#$ -pe def_slot 1
set -ex
VERSION_NAME=$1
OUTPUTDIR_INITIALIZE=0

# ============================================================
# lists and ids
# ============================================================

PATIENT_LIST="${HOME}/database/links/corrected/all.txt"
read TUMOR_ID TUMOR_HASH NORMAL_ID NORMAL_HASH < <(
  awk -v line="${SGE_TASK_ID}" -F '\t' 'NR==line {print $1, $2, $3, $4}' "$PATIENT_LIST"
)
PROJECT_NAME="$(echo "$TUMOR_ID" | cut -d '-' -f2)-01"

# ============================================================
# commond files
# ============================================================

TUMOR_BAM=${HOME}/database/links/${PROJECT_NAME}/result/wgs/${TUMOR_ID}/bam/${TUMOR_HASH}/${TUMOR_HASH}.markdup.bam
NORMAL_BAM=${HOME}/database/links/${PROJECT_NAME}/result/wgs/${TUMOR_ID}/bam/${NORMAL_HASH}/${NORMAL_HASH}.markdup.bam
FASTA=${HOME}/database/reference/Homo_sapiens_assembly38.fasta

# ============================================================
# id verification and outputdir creation
# ============================================================

: "${VERSION_NAME:?VERSION_NAME is empty}"
: "${PROJECT_NAME:?PROJECT_NAME is empty}"
: "${TUMOR_ID:?TUMOR_ID is empty}"

echo JOBID: $JOB_ID
echo SGE_TASK_ID: $SGE_TASK_ID
echo TUMOR_ID: $TUMOR_ID
echo NORMAL_ID: $NORMAL_ID

OUTPUTDIR=result_${VERSION_NAME}/${PROJECT_NAME}/${TUMOR_ID}
LOGDIR=log
LOGDIRSUCCESS=log_success
LOGDIRFAILED=log_failed


if [[ "${OUTPUTDIR_INITIALIZE:-0}" -eq 1 ]]; then
  echo "initializing outputdir: $OUTPUTDIR"
  if [[ -d $OUTPUTDIR ]]; then
    rm -rf -- "$OUTPUTDIR"
  fi
else
  echo "do not initialize outputdir: $OUTPUTDIR"
fi

mkdir -p -- "$OUTPUTDIR"
mkdir -p -- "$LOGDIR"
mkdir -p -- "$LOGDIRSUCCESS"
mkdir -p -- "$LOGDIRFAILED"


finalize_logs() {
  local status=$1

  set +e

  local destdir
  local status_label

  if [[ "$status" -eq 0 ]]; then
    destdir="$LOGDIRSUCCESS"
    status_label="success"
  else
    destdir="$LOGDIRFAILED"
    status_label="failed"
  fi

  mkdir -p -- "$destdir"

  local efile="${LOGDIR}/${JOB_NAME}.e${JOB_ID}.${SGE_TASK_ID}"
  local ofile="${LOGDIR}/${JOB_NAME}.o${JOB_ID}.${SGE_TASK_ID}"

  if [[ -f "$efile" ]]; then
    mv -f -- "$efile" "${destdir}/${JOB_NAME}.e${JOB_ID}.${SGE_TASK_ID}.${TUMOR_ID}.${status_label}"
  fi

  if [[ -f "$ofile" ]]; then
    mv -f -- "$ofile" "${destdir}/${JOB_NAME}.o${JOB_ID}.${SGE_TASK_ID}.${TUMOR_ID}.${status_label}"
  fi

  exit "$status"
}

trap 'finalize_logs $?' EXIT

# ============================================================
# job
# ============================================================

echo -e "id\n${TUMOR_ID}" > $OUTPUTDIR/${TUMOR_ID}.txt

