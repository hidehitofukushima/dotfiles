#!/bin/bash
#$ -S /usr/bin/bash
#$ -cwd
#$ -l s_vmem=1G
#$ -pe def_slot 1
#$ -t 1-1:1 
#$ -tc 500
#$ -o log/
#$ -e log/
set -ex

VERSION_NAME=v1
PROJECT_NAME=ORIGINAL_COHORT

###############################################################################
# additional parameters
###############################################################################
# sample
##$ -t 1-1:1
# AL-01
##$ -t 1298-1453:1
# AY-01
##$ -t 1-524:1
# MD-01
##$ -t 1-439:1
# ML-01
##$ -t 1047-1297:1
# MP-01
##$ -t 1-83:1
# AB-01 
##$ -t 1-289:1
##$ -l ljob

###############################################################################
# lists and ids
###############################################################################
PATIENT_LIST="${HOME}/database/links/corrected/all.txt"
TUMOR_ID=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $1}')
TUMOR_HASH=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $2}')
NORMAL_ID=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $3}')
NORMAL_HASH=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $4}')
PROJECT_NAME=$(echo $TUMOR_ID | cut -d '-' -f 2)-01

###############################################################################
# common files
###############################################################################
TUMOR_BAM=${HOME}/database/links/${PROJECT_NAME}/result/wgs/${TUMOR_ID}/bam/${TUMOR_HASH}/${TUMOR_HASH}.markdup.bam
NORMAL_BAM=${HOME}/database/links/${PROJECT_NAME}/result/wgs/${TUMOR_ID}/bam/${NORMAL_HASH}/${NORMAL_HASH}.markdup.bam
FASTA=${HOME}/database/reference/Homo_sapiens_assembly38.fasta

###############################################################################
# id verification and outputdir creation
###############################################################################
echo SCRIPTNAME: $0
echo VERSION_NAME: $VERSION_NAME
echo JOBID: $JOB_ID
echo SGE_TASK_ID: $SGE_TASK_ID
echo TUMOR_ID: $TUMOR_ID
echo TUMOR_HASH: $TUMOR_HASH
echo NORMAL_ID: $NORMAL_ID
echo NORMAL_HASH: $NORMAL_HASH
echo TUMOR_BAM: $TUMOR_BAM
echo NORMAL_BAM: $NORMAL_BAM
echo FASTA: $FASTA

ls $TUMOR_BAM $NORMAL_BAM 

OUTPUTDIR=result_${VERSION_NAME}/${PROJECT_NAME}/${TUMOR_ID}
LOGDIR=log
LOGDIRSUCCESS=log_success

# ディレクトリの削除（!!!!!!!!!!!適宜コメントアウト!!!!!!!!!!!）
if [ -d $OUTPUTDIR ]; then
    rm -rf $OUTPUTDIR
fi

# ディレクトリがない場合の新規作成（!!!!!!!!!!!これはこのまま放置!!!!!!!!!!!）
if [ ! -d $OUTPUTDIR ]; then
    mkdir -p $OUTPUTDIR
fi

# ディレクトリがない場合の新規作成（!!!!!!!!!!!これはこのまま放置!!!!!!!!!!!）
if [ ! -d $LOGDIR ]; then
    mkdir -p $LOGDIR
fi

if [ ! -d $LOGDIRSUCCESS ]; then
    mkdir -p $LOGDIRSUCCESS
fi
###############################################################################
# job 
###############################################################################

echo -e "id\n${TUMOR_ID}" > $OUTPUTDIR/${TUMOR_ID}.txt

###############################################################################
# idの変換(ny1fhのみ)
###############################################################################

# convertfile=/home/ny1fh/database/convert/convert.tsv
# TUMOR_ID_CONVERTED=$(grep -w $TUMOR_ID $convertfile | cut -f1)
# NORMAL_ID_CONVERTED=$(grep -w $NORMAL_ID $convertfile | cut -f3)
# echo $TUMOR_ID_CONVERTED $NORMAL_ID_CONVERTED	


###############################################################################
# move log if success
###############################################################################
#
mv log/${JOB_NAME}.e${JOB_ID}.${SGE_TASK_ID} $LOGDIRSUCCESS/
mv log/${JOB_NAME}.o${JOB_ID}.${SGE_TASK_ID} $LOGDIRSUCCESS/




