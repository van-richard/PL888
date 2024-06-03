#module load intel/2021.2.0
#module load impi/2021.2.0

#source /scratch/van/.Programs/amber22/amber.sh
#export PATH=/scratch/van/.Programs/amber22/bin:${PATH}
#export LD_LIBRARY_PATH=/scratch/van/.Programs/amber22/lib:${LIB_LIBRARY_PATH}

#source /home/van/.Programs/qchem/trunk2/setqc.sh

export MKLROOT=/opt/intel/oneapi/mkl/2021.2.0
export LD_PRELOAD=$MKLROOT/lib/intel64/libmkl_core.so:$MKLROOT/lib/intel64/libmkl_sequential.so
export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so
export I_MPI_THREAD_YIELD=3
export I_MPI_THREAD_SLEEP=200

#eval "$(/home/van/.Programs/miniforge3/bin/conda shell.bash hook)" 
#conda activate /scratch/van/shared_envs/qmhub


