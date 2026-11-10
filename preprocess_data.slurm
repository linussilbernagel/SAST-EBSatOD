#!/bin/bash
#SBATCH --job-name=sast_pre
#SBATCH --cluster=gpu
#SBATCH --partition=rtx6k
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --gres=gpu:1
#SBATCH --mem=96G
#SBATCH --time=8:00:00
#SBATCH --account=ageorge
#SBATCH --output=/ihome/ageorge/lms243/shrec/SAST-EBSatOD/slurm_output/preprocess.out

source /vast/ageorge/lms243/miniconda3/bin/activate sast

export ECF_INSTALL="/vast/ageorge/lms243/software/prophesee_ecf"
export HDF5_PLUGIN_PATH="$ECF_INSTALL/lib/hdf5/plugin"
export LD_LIBRARY_PATH="$ECF_INSTALL/lib:$ECF_INSTALL/lib/hdf5/plugin:$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"

DATA_DIR=~/datasets/h5_pure/
DEST_DIR=/vast/ageorge/lms243/datasets/SAST_data/

cd ~/shrec/SAST-EBSatOD/scripts/genx/

python preprocess_dataset.py ${DATA_DIR} ${DEST_DIR} conf_preprocess/representation/stacked_hist.yaml conf_preprocess/extraction/const_duration.yaml conf_preprocess/filter_viso.yaml -ds viso -np 16

