#!/bin/bash
#SBATCH -p express
#SBATCH -t 01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --output=%j-sqm.out
#SBATCH --error=%j-sqm.err
#SBATCH --job-name=fmatch

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

dir=`pwd`

#seq -w 0 41 | while read w; do
echo "00" | while read w; do
cd ../../${w}
mkdir -p sqmfmatch
ln -sf ${dir}/sqm_training_set.py .
# ln -sf ${dir}/qm_elem.txt .
python -u sqm_training_set.py
cd $dir
done

date

