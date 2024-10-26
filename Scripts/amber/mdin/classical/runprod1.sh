#!/bin/bash
#SBATCH -p bullet
#SBATCH -t 5-00:00:00
#SBATCH -J mdin
#SBATCH -N 1
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH --ntasks-per-node=1
#SBATCH --mem=5G
#SBATCH --gres=gpu:1

date

module load amber/23-gpu

#init="step3_pbcsetup_1264"
source env.sh
pmemd="pmemd.cuda"

printf -v pstep "prod%02d" $1
printf -v istep "prod%02d" $2
echo "$pstep $istep"

$pmemd -O -i prod1.mdin \
    -p ${init}.parm7 \
    -c ${pstep}.rst7 \
    -o ${istep}.mdout \
    -r ${istep}.rst7 \
    -inf ${istep}.mdinfo \
    -ref ${init}.rst7 \
    -x ${istep}.nc

date

