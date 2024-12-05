#!/bin/bash
#SBATCH --partition=batch
#SBATCH --ntasks=160            # ntasks = n_windows * n_cores
#SBATCH --ntasks-per-node=8     # n_cores = 4. 2 simulations per node
#SBATCH --output=log/%j.out
#SBATCH --error=log/%j.err
#SBATCH --time=1-00:00:00
#SBATCH --job-name=sander2

date

module load amber/23-panxl
module load qmhub

export I_MPI_COMPATIBILITY=3

run=0
windows=40

#SANDER="srun -n ${SLURM_NTASKS} sander.MPI"
SANDER="srun sander.MPI -ng ${windows}"

mkdir results
bash gen_groupfile.sh ${run} ${windows} 
$SANDER -groupfile groupfile

# Organize
mv results results_${run}
python reorgnize_ncrst.py ${run}
ln -s results_${run}/final_parameters.dat .
ln -s results${run}/${run}_final.string .

date

