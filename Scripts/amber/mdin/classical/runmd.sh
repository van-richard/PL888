#!/bin/bash
#SBATCH -p bullet
#SBATCH -t 24:00:00
#SBATCH -J md
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
##SBATCH --mem=5G
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --gres=gpu:1

date

source env.sh

module load amber/23-gpu
pmemd="pmemd.cuda"

$pmemd -O -i heat.mdin \
    -p ${init}.parm7 \
    -c min.rst7 \
    -o heat.mdout \
    -r heat.rst7 \
    -inf heat.mdinfo \
    -ref ${init}.rst7 \
    -x heat.nc

$pmemd -O -i density.mdin \
    -p ${init}.parm7 \
    -c heat.rst7 \
    -o density.mdout \
    -r density.rst7 \
    -inf density.mdinfo \
    -ref ${init}.rst7 \
    -x density.nc

$pmemd -O -i prod0.mdin \
    -p ${init}.parm7 \
    -c density.rst7 \
    -O -o prod00.mdout \
    -r prod00.rst7 \
    -inf prod00.mdinfo \
    -ref ${init}.rst7 \
    -x prod00.nc

date


