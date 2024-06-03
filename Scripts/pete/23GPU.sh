module load gcc/11.2.0
module load mvapich2-2.2-psm/gcc
module load cuda/12.1

source /scratch/van/.Programs/23GPU/amber.sh

eval "$(/home/van/miniforge3/bin/conda shell.bash hook)"
conda activate /scratch/van/shared_envs/ambertools23 
