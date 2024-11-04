#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1
#SBATCH --ntasks-per-node=16
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --time=5-00:00:00
#SBATCH --job-name=sinr

date
module load amber/23-panxl
module load qchem
module load qmhub

# For QMHub only
export MKL_NUM_THREADS=${SLURM_NTASKS_PER_NODE}
export OMP_NUM_THREADS=${SLURM_NTASKS_PER_NODE}

init="step3_pbcsetup"
SANDER="srun -n ${SLURM_NTASKS_PER_NODE} sander.MPI"

# First Round

istep="step5.00_equilibration"

cd 00
$SANDER -O -i ${istep}.mdin -o ${istep}.mdout -p ${init}.parm7 -c ${istep}_inp.rst7 -r ${istep}.ncrst -x ${istep}.nc -inf ${istep}.mdinfo
cp ${istep}.ncrst ../01/${istep}_inp.ncrst
cd -

for i in `seq 1 39`; do
    printf -v j "%02d" $i
    cd $j
    $SANDER -O -i ${istep}.mdin -o ${istep}.mdout -p ${init}.parm7 -c ${istep}_inp.ncrst -r ${istep}.ncrst -x ${istep}.nc -inf ${istep}.mdinfo
    printf -v j "%02d" $(($i + 1))
    cp ${istep}.ncrst ../${j}/${istep}_inp.ncrst
    cd -
done

