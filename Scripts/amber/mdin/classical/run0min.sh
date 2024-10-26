#!/bin/bash

init="step3_pbcsetup_1264"

sbatch <<_EOF
#!/bin/bash
#SBATCH -p express
#SBATCH -t 00:30:00
#SBATCH --ntasks-per-node=32
#SBATCH --job-name=$(basename $(pwd))
#SBATCH --output=%j.out
#SBATCH --error=%j.err

date

module load amber/23-gpu

pmemd="mpirun -n \${SLURM_NTASKS} pmemd.MPI"

# Run minimization (generally best on CPU)
\$pmemd -i min.mdin -p ${init}.parm7 -c ${init}.rst7 -O -o min.mdout -r min.rst7 -ref ${init}.rst7 -inf min.mdinfo 

date

_EOF

