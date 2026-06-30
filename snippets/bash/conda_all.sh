wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
eval "$(~/miniconda3/bin/conda shell.bash hook)"
conda list
conda update --all
conda config --set auto_activate_base false
conda config --add channels bioconda
conda config --add channels conda-forge
conda create -n aligners bwa bowtie hisat2 star
conda activate aligners
conda deactivate
