#!/bin/bash

date

pstep="step6.00"
istep="step6.01"

nwindow=41
ncpu=28
cpu_per_task=4
njob=$(( ${ncpu} / ${cpu_per_task} ))

wdir=$(realpath .) 
name=$(basename $wdir)

if [ ! -f "runmd.sh" ]; then
    cat <<_EOF >runmd.sh
#!/bin/bash

date
w=$1 # window
i=$2
p=$3

cd \$w

module load amber/23-panxl
module load torchmdnet

export MKL_NUM_THREADS=\${SLURM_NTASKS_PER_NODE}
export OMP_NUM_THREADS=\${SLURM_NTASKS_PER_NODE}

SANDER="srun -n \${SLURM_NTASKS_PER_NODE} sander.MPI"

# pstep="\${p}_equilibration_inp" # initial pull
pstep="\${p}_equilibration"
istep="\${i}_equilibration"

if [ ! -f "\${i}_equilibration.mdin" ]; then
    sed "s/\${p}/\${i}/" \${pstep}.mdin > ${istep}.mdin
fi

\\$SANDER -O -i \${istep}.mdin -p step3_pbcsetup.parm7 -c \${pstep}.ncrst -o \${istep}.mdout -r \${istep}.ncrst -x \${istep}.nc -inf \${istep}.mdinfo

date

_EOF


for job in $(seq 0 ${njob} 35); do
    i=${job}
    j=$(( ${i}+6 ))

sbatch <<-_EOF
#!/bin/bash
#SBATCH -p batch
#SBATCH -t 5-00:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=4
#SBATCH -J QMMM-MLP
#SBATCH -o log/%j.out
#SBATCH -e log/%j.err

date

module load parallel/2024

hostname

parallel \
    --jobs ${njob} \
    bash runmd.sh {} ${istep} ${pstep} ::: \$(seq -f"%02g" ${i} ${j})

date
_EOF

done


