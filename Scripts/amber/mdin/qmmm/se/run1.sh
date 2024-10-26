#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1
#SBATCH --ntasks-per-node=16
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH -t 10:00:00
#SBATCH -J h98

date

declare sander="srun -n ${SLURM_NTASKS_PER_NODE} sander.MPI"
declare init="step3_pbcsetup"
declare istep="step5.00_equilibration"
declare jstep="step5.00_quilibration"
declare cwd=$(pwd)

declare -a windows
windows=($(seq -w ${1} 19 ))


module load amber/23-panxl
module load qchem/5.2
module load qmhub

export MKL_NUM_THREADS=${SLURM_NTASKS_PER_NODE}
export OMP_NUM_THREADS=${SLURM_NTASKS_PER_NODE}

for window in "${windows[@]}"; do
    cd ${cwd}/${window}
    
    if [[ "${window}" -ne "${input}" ]]; then
        cp ${OLDPWD}/sinrvels.rst .
        ln -sf ${OLDPWD}/${istep}.ncrst ${istep}_inp.ncrst
    fi

    ${sander} -O -i ${istep}.mdin -p ${init}.parm7 -c ${istep}_inp.ncrst -o ${istep}.mdout -r ${istep}.ncrst -x ${istep}.nc -inf ${istep}.mdinfo
done

date

