#!/bin/bash

init="step3_pbcsetup"

if [ -z $1 ]; then
    echo "Need $pstep value"
    exit 1
else
    printf -v p "%02d" $1
fi

if [ -z $2 ]; then
    echo "Need $istep value"
    exit 1
else
    printf -v i "%02d" $2
fi

pstep="prod${p}"
istep="prod${i}"
echo "$pstep $istep"

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
