#!/bin/bash
#SBATCH -p express
#SBATCH -t 01:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=32
#SBATCH -J MD min
#SBATCH -o log/%j.out
#SBATCH -e log/%j.err

date

module load amber/23
# module load amber/23-gpu

PMEMD="mpirun -n ${SLURM_NTASKS_PER_NODE} pmemd.MPI"

init="step3_pbcsetup"
istep="step5.00_equilibration"

$PMEMD -O -i ${istep}.mdin -p ${init}.parm7 -c ${init}.rst7 -o ${istep}.mdout -r ${istep}.ncrst -x ${istep}.nc -inf ${istep}.mdinfo
