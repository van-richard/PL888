#!/bin/bash

mkdir -p log

module load amber/23-gpu

init="step3_pbcsetup"
pmemd="mpirun -n 20 pmemd.MPI"

# Run minimization (generally best on CPU)
$pmemd -i min.mdin -p ${init}.parm7 -c ${init}.rst7 -O -o min.mdout -r min.rst7 -ref ${init}.rst7

# Submit job for equilibration/production
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

module load amber/23-gpu

pmemd="pmemd.cuda"

# Heating
\$pmemd -i heat.mdin -p ${init}.parm7 -c min.rst7 -O -o heat.mdout -r heat.rst7 -inf heat.mdinfo -ref ${init}.rst7 -x heat.nc

# Pressure
\$pmemd -i density.mdin -p ${init}.parm7 -c heat.rst7 -O -o density.mdout -r density.rst7 -inf density.mdinfo -ref ${init}.rst7 -x density.nc

# NVT
\$pmemd -i prod.mdin -p ${init}.parm7 -c density.rst7 -O -o prod00.mdout -r prod00.rst7 -inf prod00.mdinfo -ref ${init}.rst7 -x prod00.nc

date

# Submit job for long production run
# Usage: bash runprod.sh [PSTEP] [ISTEP]
bash runprod.sh 0 1

_EOF

