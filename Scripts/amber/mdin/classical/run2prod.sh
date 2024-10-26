#!/bin/bash
#SBATCH -p bullet
#SBATCH -t 5-00:00:00
#SBATCH -J mdin
#SBATCH -N 1
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH --ntasks-per-node=1
#SBATCH --mem=5G
#SBATCH --gres=gpu:1

date

module load amber/23-gpu

source env.sh
pmemd="pmemd.cuda"

pstep="density"
istep="prod00"

$pmemd -O -i prod1.mdin \
    -p ${init}.parm7 \
    -c ${pstep}.rst7 \
    -o ${istep}.mdout \
    -r ${istep}.rst7 \
    -inf ${istep}.mdinfo \
    -ref ${init}.rst7 \
    -x ${istep}.nc

date

