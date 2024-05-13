#!/bin/bash

module load Amber

init="step3_pbcsetup"
pmemd="mpirun -n 20 pmemd.MPI"
$pmemd -i min.mdin -p ${init}.parm7 -c ${init}.rst7 -O -o min.mdout -r min.rst7 -ref ${init}.rst7

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

\$pmemd -i heat.mdin -p ${init}.parm7 -c min.rst7 -O -o heat.mdout -r heat.rst7 -inf heat.mdinfo -ref min.rst7 -x heat.nc

\$pmemd -i density.mdin -p ${init}.parm7 -c heat.rst7 -O -o density.mdout -r density.rst7 -inf density.mdinfo -ref heat.rst7 -x density.nc

\$pmemd -i prod2.mdin -p ${init}.parm7 -c density.rst7 -O -o prod00.mdout -r prod00.rst7 -inf prod00.mdinfo -ref ${init}.rst7 -x prod00.nc

date

sbatch runprod.sh

_EOF

