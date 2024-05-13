#!/bin/bash

pstep="prod00"
istep="prod01"
init="step3_pbcsetup"

sbatch <<_EOF
#!/bin/bash
#SBATCH -p a100
#SBATCH -t 1-00:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=5G
#SBATCH --job-name=$(basename $(pwd))
#SBATCH --output=log/%j.out
#SBATCH --error=log/%j.err
#SBATCH --gres=gpu:1

date

module load AmberGPU
pmemd="pmemd.cuda"

\$pmemd -i prod2.mdin \
    -p ${init}.parm7 \
    -c ${pstep}.rst7 \
    -o ${istep}.mdout \
    -r ${istep}.rst7 \
    -inf ${istep}.mdinfo \
    -ref ${init}.rst7 \
    -x ${istep}.nc

date

_EOF
