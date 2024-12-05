#!/bin/bash
#SBATCH -p batch
#SBATCH -t 30:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=0chargefmatch
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

SANDER="srun -n 16 sander.MPI"

init="step3_pbcsetup.0"
pstep="step5.00_equilibration"
istep="step7_reprocessing2"
traj="all_step6"

# Print this working directory and window
w=$(sed -n "$SLURM_ARRAY_TASK_ID"p list)
dir=`pwd`
echo "Window ${w}"

cd ../../${w}
cp ${dir}/step3_pbcsetup.0.parm7 .
ln -sf ${dir}/dedup.sh .
ln -sf ${dir}/qmhub2-reprocess.ini .
sed "s/__WIN__/${w}/" ${dir}/${istep}.mdin > ${istep}.mdin
rm -fr qmhub-reprocess
echo "Starting Reprocessing!"
$SANDER -O -i ${istep}.mdin -o  ${istep}.mdout -p ${init}.parm7 -c ${pstep}.ncrst -y ${traj}.nc -x ${istep}.nc

date

cp -r qmhub-reprocess qmhub-reprocess-copy

# Clean up...
cd qmhub-reprocess
bash ../dedup.sh

date

