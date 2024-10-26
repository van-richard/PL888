#!/bin/bash

init="step3_pbcsetup_1264"
#pmemd="mpirun -n 16 pmemd.MPI"
pmemd="pmemd.cuda"
#module="amber/23-gpu"
#module="Amber/22.4-foss-2022a-AmberTools-23.5-CUDA-11.7.0"
module="AmberGPU"
part="a100"

# Submit job for equilibration/production
sbatch <<_EOF
#!/bin/bash
#SBATCH -p $part
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
##SBATCH --mem=5G
#SBATCH --job-name=$(basename $(pwd))
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --gres=gpu:1
##SBATCH --exclude=c301,c302

date

module load ${module}

# Pressure
$pmemd -i density.mdin -p ${init}.parm7 -c heat.rst7 -O -o density.mdout -r density.rst7 -inf density.mdinfo -ref ${init}.rst7 -x density.nc

date

_EOF

