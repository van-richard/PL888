#!/bin/bash
#SBATCH -p bullet
#SBATCH -t 5-00:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=5G
#SBATCH -J MD GPU
#SBATCH -o log/%j.out
#SBATCH -e log/%j.err
#SBATCH --gres=gpu:1

date

module load amber/23-gpu

PMEMD="pmemd.cuda"

init="step3_pbcsetup"
istep="step5.00_equilibration"

$PMEMD -O -i ${istep}.mdin -p ${init}.parm7 -c ${init}.rst7 -o ${istep}.mdout -r ${istep}.ncrst -x ${istep}.nc -inf ${istep}.mdinfo
