#!/bin/bash
#SBATCH --partition=longjobs
#SBATCH --exclusive
#SBATCH --ntasks=20
#SBATCH --ntasks-per-node=20
#SBATCH --mem=0
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --time=168:00:00
#SBATCH --job-name=sinr

date
module load intel/2020a
source /home/panxl/qchem/trunk2/setqc.sh
source /home/panxl/amber20/amber.sh
export UCX_TLS=all

# For QMHub only
eval "$(/home/panxl/.local/opt/miniforge3/bin/conda shell.bash hook)"
conda activate

export I_MPI_PIN=0
export I_MPI_THREAD_YIELD=3
export I_MPI_THREAD_SLEEP=200
export I_MPI_OFI_PROVIDER=verbs

# For QMHub only
export MKL_NUM_THREADS=16
export OMP_NUM_THREADS=16

SANDER="mpiexec.hydra -bootstrap slurm -n 16 sander.MPI"

init="step3_pbcsetup"

# First Round

istep="step5.00_equilibration"

for i in `seq 0 39`; do
    printf -v j "%02d" $i
    cd $j
    $SANDER -O -i ${istep}.mdin -o ${istep}.mdout -p ${init}.parm7 -c ${istep}_inp.ncrst -r ${istep}.ncrst -x ${istep}.nc -inf ${istep}.mdinfo
    printf -v j "%02d" $(($i + 1))
    cp ${istep}.ncrst ../${j}/${istep}_inp.ncrst
    cp sinrvels.rst ../${j}/
    cd ..
done

