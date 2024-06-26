#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1
#SBATCH --ntasks=32
##SBATCH --ntasks-per-node=32
#SBATCH --output=log/%j.out
#SBATCH --error=log/%j.err
#SBATCH --time=2-00:00:00
#SBATCH --job-name=sander1

date

module load amber/23-panxl

SANDER="srun -n ${SLURM_NTASKS} sander.MPI"
#SANDER="srun -n ${SLURM_NTASKS_PER_NODE} sander.MPI"

init="step3_pbcsetup"

# First Round
# istep="step5.00_equilibration"
# 
# for i in `seq 0 39`; do
#     printf -v j "%02d" $i
#     cd $j
#     $SANDER -O -i ${istep}.mdin -o ${istep}.mdout -p ${init}.parm7 -c ${istep}_inp.ncrst -r ${istep}.ncrst -x ${istep}.nc -inf ${istep}.mdinfo
#     printf -v k "%02d" $(($i + 1))
#     cp ${istep}.ncrst ../$k/${istep}_inp.ncrst
#     cd ..
# done

# Second Round
pstep="step5.00_equilibration"
istep="step5.01_equilibration"

cp 39/${pstep}_inp.ncrst 39/${istep}_inp.ncrst

for i in `seq 39 -1 0`; do
    printf -v j "%02d" $i
    cd $j
    sed "s/${pstep}/${istep}/" ${pstep}.mdin > ${istep}.mdin
    $SANDER -O -i ${istep}.mdin -o ${istep}.mdout -p ${init}.parm7 -c ${istep}_inp.ncrst -r ${istep}.ncrst -x ${istep}.nc -ref ${init}.ncrst -inf ${istep}.mdinfo
    printf -v k "%02d" $(($i - 1))
    cp ${istep}.ncrst ../$k/${istep}_inp.ncrst
    cd ..
done

