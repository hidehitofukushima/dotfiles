echo:
	echo "hello"

###############################################
# 各疾患の実行
# 使用方法
# make al_v1で AL-01に対して master_v1.sh が実行される
# make al_v2で AL-01に対して master_v2.sh が実行される
# make alrna_v1で AL-01に対して master_rna_v1.sh が実行される
# make alrna_v2で AL-01に対して master_rna_v2.sh が実行される
# make al2_v1で AL-01に対して master_v1.sh がスクリプト内部の -t オプションを用いて実行される
# make al2_v2で AL-01に対して master_v2.sh がスクリプト内部の -t オプションを用いて実行される
# make alrna2_v1で AL-01に対して master_rna_v1.sh がスクリプト内部の -t オプションを用いて実行される
# make alrna2_v2で AL-01に対して master_rna_v2.sh がスクリプト内部の -t オプションを用いて実行される
###############################################
# DNA版
s_%:
	qsub -t 1-1:1 -N $(notdir ${PWD})_${*} master_${*}.sh AL-01 ${*} $(notdir ${PWD})_${*}
al_%:
	qsub -t 1-156:1 -N $(notdir ${PWD})_${*} master_${*}.sh AL-01 ${*} $(notdir ${PWD})_${*}
ay_%:
	qsub -t 1-524:1 -N $(notdir ${PWD})_${*} master_${*}.sh AY-01 ${*} $(notdir ${PWD})_${*}
md_%:
	qsub -t 1-439:1 -N $(notdir ${PWD})_${*} master_${*}.sh MD-01 ${*} $(notdir ${PWD})_${*}
ml_%:
	qsub -t 1-251:1 -N $(notdir ${PWD})_${*} master_${*}.sh ML-01 ${*} $(notdir ${PWD})_${*}
mp_%:
	qsub -t 1-83:1 -N $(notdir ${PWD})_${*} master_${*}.sh MP-01 ${*} $(notdir ${PWD})_${*}

# RNA 版
srna_%:
	qsub -t 1-1:1 -N $(notdir ${PWD})_${*} master_rna_${*}.sh AL-01 ${*} $(notdir ${PWD})_${*}
alrna_%:
	qsub -t 1-89:1 -N $(notdir ${PWD})_${*} master_rna_${*}.sh AL-01 ${*} $(notdir ${PWD})_${*}
ayrna_%:
	qsub -t 1-300:1 -N $(notdir ${PWD})_${*} master_rna_${*}.sh AY-01 ${*} $(notdir ${PWD})_${*}
mdrna_%:
	qsub -t 1-250:1 -N $(notdir ${PWD})_${*} master_rna_${*}.sh MD-01 ${*} $(notdir ${PWD})_${*}
mlrna_%:
	qsub -t 1-185:1 -N $(notdir ${PWD})_${*} master_rna_${*}.sh ML-01 ${*} $(notdir ${PWD})_${*}
mprna_%:
	qsub -t 1-64:1 -N $(notdir ${PWD})_${*} master_rna_${*}.sh MP-01 ${*} $(notdir ${PWD})_${*}


###############################################
# 各疾患の実行(アレイidは、master_vx.shの中で細かく指定する)
###############################################
# DNA版
al2_%:
	qsub -N $(notdir ${PWD})_${*} master_${*}.sh AL-01 ${*} $(notdir ${PWD})_${*}
ay2_%:
	qsub -N $(notdir ${PWD})_${*} master_${*}.sh AY-01 ${*} $(notdir ${PWD})_${*}
md2_%:
	qsub -N $(notdir ${PWD})_${*} master_${*}.sh MD-01 ${*} $(notdir ${PWD})_${*}
ml2_%:
	qsub -N $(notdir ${PWD})_${*} master_${*}.sh ML-01 ${*} $(notdir ${PWD})_${*}
mp2_%:
	qsub -N $(notdir ${PWD})_${*} master_${*}.sh MP-01 ${*} $(notdir ${PWD})_${*}
# RNA版
alrna2_%:
	qsub -N $(notdir ${PWD})_${*} master_rna_${*}.sh AL-01 ${*} $(notdir ${PWD})_${*}
ayrna2_%:
	qsub -N $(notdir ${PWD})_${*} master_rna_${*}.sh AY-01 ${*} $(notdir ${PWD})_${*}
mdrna2_%:
	qsub -N $(notdir ${PWD})_${*} master_rna_${*}.sh MD-01 ${*} $(notdir ${PWD})_${*}
mlrna2_%:
	qsub -N $(notdir ${PWD})_${*} master_rna_${*}.sh ML-01 ${*} $(notdir ${PWD})_${*}
mprna2_%:
	qsub -N $(notdir ${PWD})_${*} master_rna_${*}.sh MP-01 ${*} $(notdir ${PWD})_${*}


###############################################
# すべて初期化
###############################################
clearall:
	rm -rf log* && rm -rf result* && rm -rf aggregate*
	mkdir -p log_raw


###############################################
# aggregate
###############################################
ag:
	./aggregate.sh

###############################################
# for various testing
###############################################
test:
	qsub -N $(notdir ${PWD}) ./test.sh ${PWD}

test_%:
	qsub -N $(notdir ${PWD})_${*} ./test_${*}.sh ${PWD}
# make test_v1 で test_v1.sh が実行される 


testal_%:
	qsub -N $(notdir ${PWD})_${*} ./test_${*}.sh ${PWD}

