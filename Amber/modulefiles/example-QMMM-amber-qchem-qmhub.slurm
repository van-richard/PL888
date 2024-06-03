#!/bin/bash
#SBATCH -p batch
#SBATCH -t 5-00:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=16
#SBATCH -J QMMM 
#SBATCH -o log/%j.out
#SBATCH -e log/%j.err

date

module load amber/23-panxl
module load qchem/5.2
module load qmhub

export MKL_NUM_THREADS=${SLURM_NTASKS_PER_NODE}
export OMP_NUM_THREADS=${SLURM_NTASKS_PER_NODE}

SANDER="mpirun -n ${SLURM_NTASKS_PER_NODE} sander.MPI" 

init="step3_pbcsetup"
istep="step5.00_equilibration"

$SANDER -O -i ${istep}.mdin -p ${init}.parm7 -c ${init}.rst7 -o ${istep}.mdout -r ${istep}.ncrst -x ${istep}.nc -inf ${istep}.mdinfo
