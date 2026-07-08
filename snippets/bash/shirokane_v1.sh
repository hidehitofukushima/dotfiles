###########################################
# version and project name specification
###########################################

#$ -S /usr/bin/bash
#$ -cwd
#$ -o log/
#$ -e log/
set -ex
VERSION_NAME=$1

###########################################
# lists and ids
###########################################

PATIENT_LIST="${HOME}/database/links/corrected/all.txt"
read TUMOR_ID TUMOR_HASH NORMAL_ID NORMAL_HASH < <(
  awk -v line="${SGE_TASK_ID}" -F '\t' 'NR==line {print $1, $2, $3, $4}' "$PATIENT_LIST"
)
PROJECT_NAME="$(echo "$TUMOR_ID" | cut -d '-' -f2)-01"
# TUMOR_ID=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $1}')
###########################################
# common files
###########################################

TUMOR_BAM=${HOME}/database/links/${PROJECT_NAME}/result/wgs/${TUMOR_ID}/bam/${TUMOR_HASH}/${TUMOR_HASH}.markdup.bam
NORMAL_BAM=${HOME}/database/links/${PROJECT_NAME}/result/wgs/${TUMOR_ID}/bam/${NORMAL_HASH}/${NORMAL_HASH}.markdup.bam
FASTA=${HOME}/database/reference/Homo_sapiens_assembly38.fasta

###########################################
# id verification and outputdir creation
###########################################

echo JOBID: $JOB_ID
echo SGE_TASK_ID: $SGE_TASK_ID
echo TUMOR_ID: $TUMOR_ID
echo NORMAL_ID: $NORMAL_ID

OUTPUTDIR=result_${VERSION_NAME}/${PROJECT_NAME}/${TUMOR_ID}
LOGDIR=log
LOGDIRSUCCESS=log_success

[ -d "$OUTPUTDIR" ] && rm -rf "$OUTPUTDIR"
[ ! -d "$OUTPUTDIR" ] && mkdir -p "$OUTPUTDIR"
[ ! -d "$LOGDIR" ] && mkdir -p "$LOGDIR"
[ ! -d "$LOGDIRSUCCESS" ] && mkdir -p "$LOGDIRSUCCESS"

###########################################
# job
###########################################

echo -e "id\n${TUMOR_ID}" > $OUTPUTDIR/${TUMOR_ID}.txt

###########################################
# move log if success
###########################################

mv log/${JOB_NAME}.e${JOB_ID}.${SGE_TASK_ID} $LOGDIRSUCCESS/
mv log/${JOB_NAME}.o${JOB_ID}.${SGE_TASK_ID} $LOGDIRSUCCESS/

