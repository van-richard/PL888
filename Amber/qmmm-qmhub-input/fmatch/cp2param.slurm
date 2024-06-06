#!/bin/bash
#SBATCH -p express
#SBATCH -t 00:15:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=cp2param

date

eval "$(/home/van/.Programs/miniforge3/bin/conda shell.bash hook)"
conda activate

python -u cp2param.py checkpoint.npy

date

