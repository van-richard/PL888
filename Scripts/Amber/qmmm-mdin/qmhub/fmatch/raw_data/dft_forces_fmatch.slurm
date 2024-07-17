#!/bin/bash
#SBATCH -p long
#SBATCH -t 7-05:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=fmatch
#SBATCH --array=1-42

date
module load intel/2021.2.0
module load impi/2021.2.0
source /home/van/.Programs/amber21/amber.sh
source /home/van/.Programs/qchem/trunk2/setqc.sh
export MKLROOT=/opt/intel/oneapi/mkl/2021.2.0
export LD_PRELOAD=$MKLROOT/lib/intel64/libmkl_core.so:$MKLROOT/lib/intel64/libmkl_sequential.so

eval "$(/home/van/.Programs/miniforge3/bin/conda shell.bash hook)"
conda activate

export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so
export I_MPI_THREAD_YIELD=3
export I_MPI_THREAD_SLEEP=200

export MKL_NUM_THREADS=16
export OMP_NUM_THREADS=16

w=$(sed -n "$SLURM_ARRAY_TASK_ID"P list)
dir=`pwd`

cd ../../${w}
cp ${dir}/dft_forces_fmatch.py .
python dft_forces_fmatch.py

date
