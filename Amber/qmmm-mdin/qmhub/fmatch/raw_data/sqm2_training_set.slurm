#!/bin/bash
#SBATCH -p batch
#SBATCH -t 1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=fmatch2
#SBATCH --array=1-41

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


date

i=$(sed -n "$SLURM_ARRAY_TASK_ID"p list)

#seq -w 36 41 | while read i; do
#echo 00 | while read i; do
echo "window $i"
cd /home/van/scratch/cas9/hnh/b3lyp-pm3-sinr/$i
mkdir -p fmatch2
ln -sf ../fmatch/param.dat .
ln -sf ../fmatch/raw_data/sqm2_training_set.py .
python -u sqm2_training_set.py 
#done


date

