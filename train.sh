#!/bin/bash
#SBATCH --job-name=sast
#SBATCH --cluster=gpu
#SBATCH --partition=a100
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --mem=80G
#SBATCH --time=4-0:00:00
#SBATCH --account=ageorge
#SBATCH --output=/ihome/ageorge/lms243/shrec/SAST-EBSatOD/slurm_output/sast_train.out

nvidia-smi
export TMPDIR=$SLURM_SCRATCH/tmp
mkdir -p "$TMPDIR"
export XDG_CACHE_HOME=$SLURM_SCRATCH/.cache
mkdir -p "$XDG_CACHE_HOME"
export UV_CACHE_DIR=$SLURM_SCRATCH/uv-cache
mkdir -p "$UV_CACHE_DIR"
export HDF5_USE_FILE_LOCKING=FALSE
export WANDB_MODE=offline

echo $TMPDIR $XDG_CACHE_HOME $UV_CACHE_DIR

source /vast/ageorge/lms243/miniconda3/bin/activate sasteb

export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:$CONDA_PREFIX/lib/python3.9/site-packages/torch/lib:$LD_LIBRARY_PATH"

# params
BATCH_SIZE_PER_GPU=8 
GPU_NUMBER=1
GPUS=1
lr=$(python -c "import math; print(2e-4*math.sqrt(${BATCH_SIZE_PER_GPU}*${GPU_NUMBER}/8))") 
DATA_DIR=/vast/ageorge/lms243/datasets/SAST_data/



python train.py model=rnndet dataset=viso dataset.path=${DATA_DIR} wandb.project_name=SAST \
                wandb.group_name=viso hardware.num_workers.train=2 batch_size.train=${BATCH_SIZE_PER_GPU} \
                hardware.num_workers.eval=2 batch_size.eval=${BATCH_SIZE_PER_GPU} \
                hardware.gpus=[${GPUS}] +experiment/viso="base.yaml" \
                training.learning_rate=${lr} validation.val_check_interval=10000

