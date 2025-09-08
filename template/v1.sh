#!/bin/bash
#$ -S /usr/bin/bash
#$ -l s_vmem=1G
#$ -pe def_slot 1
#$ -t 1-1:1 
#$ -cwd
#$ -tc 500
#$ -o log/
#$ -e log/
set -ex

###############################################################################
# 追加で使えそうなパラメータ
###############################################################################
# sample
##$ -t 1-1:1
# AL-01
##$ -t 1-156:1
# AY-01
##$ -t 1-524:1
# MD-01
##$ -t 1-439:1
# ML-01
##$ -t 1-251:1
# MP-01
##$ -t 1-83:1
# AB-01 
##$ -t 1:289:1
##$ -l ljob

###############################################################################
# リストと、IDの取得
###############################################################################
PATIENT_LIST="${HOME}/database/links/corrected/all.txt"
TUMOR_ID=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $1}')
TUMOR_HASH=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $2}')
NORMAL_ID=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $3}')
NORMAL_HASH=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $4}')
PROJECT_NAME=$(echo $TUMOR_ID | cut -d '-' -f 2)-01
VERSION_NAME=$(basename (basename $0) .sh)

###############################################################################
# よく使用するファイルのパスの取得
###############################################################################
TUMOR_BAM=${HOME}/database/links/${PROJECT_NAME}/result/wgs/${TUMOR_ID}/bam/${TUMOR_HASH}/${TUMOR_HASH}.markdup.bam
NORMAL_BAM=${HOME}/database/links/${PROJECT_NAME}/result/wgs/${TUMOR_ID}/bam/${NORMAL_HASH}/${NORMAL_HASH}.markdup.bam
FASTA=${HOME}/database/reference/Homo_sapiens_assembly38.fasta

###############################################################################
# id類の確認とoutputdirの作成（もうある場合は、一応消さないでそのまま続行できるようにしておく、一部を削除する場合は適宜変更したスクリプトを作成すればよい。
###############################################################################
echo JOBID: $JOB_ID
echo SGE_TASK_ID: $SGE_TASK_ID
echo TUMOR_ID: $TUMOR_ID
echo TUMOR_HASH: $TUMOR_HASH
echo NORMAL_ID: $NORMAL_ID
echo NORMAL_HASH: $NORMAL_HASH
echo TUMOR_BAM: $TUMOR_BAM
echo NORMAL_BAM: $NORMAL_BAM
echo FASTA: $FASTA
ls $TUMOR_BAM $NORMAL_BAM $FASTA

OUTPUTDIR=result_${VERSION_NAME}/${PROJECT_NAME}/${TUMOR_ID}
LOGDIR=log_${VERSION_NAME}/${PROJECT_NAME}/${TUMOR_ID}

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
###############################################################################
# ジョブの本体
###############################################################################

echo -e "id\n${TUMOR_ID}" > $OUTPUTDIR/${TUMOR_ID}.txt

###############################################################################
# ログの移動(一番最後に。これにより、ジョブが失敗した場合にはログがlogフォルダにそのままのこるので、そのままデバッグできます。)
###############################################################################
#
# mv log_raw/${JOB_NAME}.e${JOB_ID}.${SGE_TASK_ID} $LOGDIR/
# mv log_raw/${JOB_NAME}.o${JOB_ID}.${SGE_TASK_ID} $LOGDIR/



