#!/bin/bash
#SBATCH --partition=normal
#SBATCH --exclusive
#SBATCH --ntasks=20
#SBATCH --ntasks-per-node=20
#SBATCH --mem=0
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --time=48:00:00
#SBATCH --job-name=sander3

source /home/panxl/intel/bin/compilervars.sh intel64
source /home/panxl/intel/impi/2019.5.281/intel64/bin/mpivars.sh
source /home/van/work/Programs/amber20/amber.sh

#SANDER="srun -n 16 sander.MPI"
SANDER="sander"

export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so
export I_MPI_THREAD_YIELD=3
export I_MPI_THREAD_SLEEP=500


init="step3_pbcsetup"

# First Round

istep="step5.00_equilibration"

for i in `seq 0 39`; do
    printf -v j "%02d" $i
    cd $j
    $SANDER -O -i ${istep}.mdin -o ${istep}.mdout -p ${init}.parm7 -c ${istep}_inp.ncrst -r ${istep}.ncrst -x ${istep}.nc -inf ${istep}.mdinfo
    printf -v j "%02d" $(($i + 1))
    cp ${istep}.ncrst ../$j/${istep}_inp.ncrst
    cd ..
done

# Second Round

pstep="step5.00_equilibration"
istep="step5.01_equilibration"

cp 39/${pstep}_inp.ncrst 39/${istep}_inp.ncrst

for i in `seq 39 -1 0`; do
    printf -v j "%02d" $i
    cd $j
    $SANDER -O -i ${istep}.mdin -o ${istep}.mdout -p ${init}.parm7 -c ${istep}_inp.ncrst -r ${istep}.ncrst -x ${istep}.nc -ref ${init}.ncrst -inf ${istep}.mdinfo
    printf -v j "%02d" $(($i - 1))
    cp ${istep}.ncrst ../$j/${istep}_inp.ncrst
    cd ..
done
