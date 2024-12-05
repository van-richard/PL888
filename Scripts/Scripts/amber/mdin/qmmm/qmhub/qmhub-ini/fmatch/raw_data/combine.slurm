#!/bin/bash
#SBATCH -p express
#SBATCH -t 1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=combine

# For QMHub only
eval "$(/home/van/.Programs/miniforge3/bin/conda shell.bash hook)"
conda activate

python combine.py
python combine1.py
python combine_sqm.py
#python combine_sqm2.py

date
