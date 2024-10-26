#!/bin/bash

init="step3_pbcsetup_1264"
pmemd="pmemd.cuda"
module="amber/23-gpu"
part='bullet'
#module="Amber/22.4-foss-2022a-AmberTools-23.5-CUDA-11.7.0"
#module="AmberGPU"
#part="a100"

# Submit job for equilibration/production
sbatch <<_EOF
#!/bin/bash
#SBATCH -p $part
#SBATCH -t 24:00:00
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

# Heating
$pmemd -i heat.mdin -p ${init}.parm7 -c min.rst7 -O -o heat.mdout -r heat.rst7 -inf heat.mdinfo -ref ${init}.rst7 -x heat.nc

# Pressure
$pmemd -i density.mdin -p ${init}.parm7 -c heat.rst7 -O -o density.mdout -r density.rst7 -inf density.mdinfo -ref ${init}.rst7 -x density.nc
#bash runden.sh

# NVT
$pmemd -i prod.mdin -p ${init}.parm7 -c density.rst7 -O -o prod00.mdout -r prod00.rst7 -inf prod00.mdinfo -ref ${init}.rst7 -x prod00.nc

date

_EOF



