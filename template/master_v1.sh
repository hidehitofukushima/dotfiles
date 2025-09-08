#!/bin/bash
#$ -S /usr/bin/bash
#$ -l s_vmem=500M
#$ -pe def_slot 1
#$ -cwd
#$ -tc 500
#$ -o log_raw/
#$ -e log_raw/
#$ -js 0
#$ -t 1-1:1 
# 基本的に-tオプションはmakefileに書いてあるがmake al2_v1など 2をつけるとこちらが実行される。デバッグややり直し用にこちらを調整する
set -euxo pipefail

###############################################################################
# 追加で使えそうなパラメータ
###############################################################################
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
##$ -js 100
##$ -l ljob


###############################################################################
# リストと、IDの取得
###############################################################################
PROJECT_NAME=$1
VERSION_NAME=$2
JOB_NAME=$3
PATIENT_LIST="${HOME}/database/links/corrected/${PROJECT_NAME}.txt"
TUMOR_ID=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $1}')
TUMOR_HASH=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $2}')
NORMAL_ID=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $3}')
NORMAL_HASH=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $4}')


###############################################################################
# よく使用するファイルのパスの取得
###############################################################################
TUMOR_BAM=/home/ny1fh/database/links/${PROJECT_NAME}/result/wgs/${TUMOR_ID}/bam/${TUMOR_HASH}/${TUMOR_HASH}.markdup.bam
NORMAL_BAM=/home/ny1fh/database/links/${PROJECT_NAME}/result/wgs/${TUMOR_ID}/bam/${NORMAL_HASH}/${NORMAL_HASH}.markdup.bam
FASTA=/home/ny1fh/database/reference/Homo_sapiens_assembly38.fasta


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
# 除外条件
###############################################################################


## sample not to include in AL-01
exclude_sample=(
    "OK-AL-0018-T-01-D"
    "CC-AL-0397-T-01-D"
    "KS-AL-0048-T-01-D"
    "KS-AL-0212-T-01-D"
    "KY-AL-0369-T-01-D"
    "OR-AL-0126-T-01-D"
    "AR-ML-0102-T-01-D"
    "AR-ML-0107-T-01-D"
    "AR-ML-0204-T-01-D"
    "CC-ML-0417-T-01-D"
    "KS-ML-0435-T-01-D"
    "DK-AY-0026-T-01-D"
    "IM-AY-0004-T-01-D"
    "KE-AY-0051-T-01-D"
    "KS-AY-0641-T-01-D"
    "TM-AY-0404-T-11-D"
    "UJ-AY-0009-T-01-D"
    "DK-MD-0051-T-01-D"
    "GM-MD-0142-T-01-D"
    "GM-MD-0410-T-01-D"
)

# もし、${TUMOR_ID}が上記のリストに含まれていたら、exitする
if [[ " ${exclude_sample[@]} " =~ " ${TUMOR_ID} " ]]; then
    exit 0
fi

###############################################################################
# ジョブの本体
###############################################################################



# template
# eval "$(~/tools/miniconda3/bin/conda shell.bash hook)"
# module use /usr/local/package/modulefiles 
echo -e "id\n${TUMOR_ID}" > $OUTPUTDIR/${TUMOR_ID}.txt





###############################################################################
# ログの移動(一番最後に。これにより、ジョブが失敗した場合にはログがlogフォルダにそのままのこるので、そのままデバッグできます。)
###############################################################################


mv log_raw/${JOB_NAME}.e${JOB_ID}.${SGE_TASK_ID} $LOGDIR/
mv log_raw/${JOB_NAME}.o${JOB_ID}.${SGE_TASK_ID} $LOGDIR/
