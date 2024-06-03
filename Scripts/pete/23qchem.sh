module load intel/2021.2.0
module load impi/2021.2.0

source /home/van/.Programs/amber21/amber.sh
source /home/van/.Programs/qchem/trunk2/setqc.sh
source /home/van/miniforge3/etc/profile.d/conda.sh
conda init
conda activate qmhub

export MKLROOT=/opt/intel/oneapi/mkl/2021.2.0
export LD_PRELOAD=$MKLROOT/lib/intel64/libmkl_core.so:$MKLROOT/lib/intel64/libmkl_sequential.so

export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so
export I_MPI_THREAD_YIELD=3
export I_MPI_THREAD_SLEEP=200

export MKL_NUM_THREADS=16
export OMP_NUM_THREADS=16

mkdir -p log

