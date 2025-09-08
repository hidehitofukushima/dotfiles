#!/bin/bash
#$ -S /usr/bin/bash
#$ -l s_vmem=500M
#$ -pe def_slot 1
#$ -cwd
#$ -tc 500
#$ -o log_raw/
#$ -e log_raw/
#$ -js 0
#$ -t 13-13:1 # 基本的にこれはmakefileに書いてあるが make ay_ などアンダーバー付きで実行するとこちらが実行される。デバッグややり直し用にこちらを調整する
set -euxo pipefail

###############################################################################
# 追加で使えそうなパラメータ
###############################################################################
# AL-01
##$ -t 1-89:1
# AY-01
##$ -t 1-300:1
# MD-01
##$ -t 1-250:1
# ML-01
##$ -t 1-185:1
# MP-01
##$ -t 1-64:1
##$ -js 100
##$ -l ljob


###############################################################################
# リストと、IDの取得
###############################################################################
PROJECT_NAME=$1
VERSION_NAME=$2
JOB_NAME=$3
PATIENT_LIST="/home/ny1fh/database/links/corrected/RNA/${PROJECT_NAME}_rna.txt"
TUMOR_ID=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $1}')
TUMOR_HASH=$(cat $PATIENT_LIST | awk -v line=${SGE_TASK_ID} -F '\t' 'NR==line {print $2}')


###############################################################################
# よく使用するファイルのパスの取得
###############################################################################
TUMOR_BAM=/home/ny1fh/database/links/${PROJECT_NAME}/result/rna/${TUMOR_ID}/star/${TUMOR_HASH}/${TUMOR_HASH}.Aligned.sortedByCoord.out.bam
FASTA=/home/ny1fh/database/reference/Homo_sapiens_assembly38.fasta


###############################################################################
# id類の確認とoutputdirの作成（もうある場合は、一応消さないでそのまま続行できるようにしておく、一部を削除する場合は適宜変更したスクリプトを作成すればよい。
###############################################################################
echo JOBID: $JOB_ID
echo SGE_TASK_ID: $SGE_TASK_ID
echo TUMOR_ID: $TUMOR_ID
echo TUMOR_HASH: $TUMOR_HASH
echo TUMOR_BAM: $TUMOR_BAM
echo FASTA: $FASTA
ls $TUMOR_BAM $FASTA

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

###############################################################################
# ジョブの本体
###############################################################################



# template
# eval "$(~/tools/miniconda3/bin/conda shell.bash hook)"
# module use /usr/local/package/modulefiles 


###############################################################################
# ログの移動(一番最後に。これにより、ジョブが失敗した場合にはログがlogフォルダにそのままのこるので、そのままデバッグできます。)
###############################################################################

mv log_raw/${JOB_NAME}.e${JOB_ID}.${SGE_TASK_ID} $LOGDIR/
mv log_raw/${JOB_NAME}.o${JOB_ID}.${SGE_TASK_ID} $LOGDIR/
