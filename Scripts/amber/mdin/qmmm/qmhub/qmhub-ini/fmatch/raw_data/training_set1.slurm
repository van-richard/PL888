#!/bin/bash
#SBATCH -p batch
#SBATCH -t 2-00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=fmatch
#SBATCH --array=40

date
module load intel/2021.2.0
module load impi/2021.2.0
source /home/van/.Programs/amber21/amber.sh
source /home/van/.Programs/qchem/trunk2/setqc.sh
export MKLROOT=/opt/intel/oneapi/mkl/2021.2.0
export LD_PRELOAD=$MKLROOT/lib/intel64/libmkl_core.so:$MKLROOT/lib/intel64/libmkl_sequential.so

eval "$(/home/van/.Programs/miniforge3/bin/conda shell.bash hook)"
conda activate

date

w=$(sed -n "$SLURM_ARRAY_TASK_ID"P list)

echo "window ${w}"

dir=`pwd`

cd ../../${w}
mkdir -p dftfmatch
ln -sf ${dir}/training_set1.py .
ln -sf ${dir}/qm_elem.txt .
python -u training_set1.py

date

