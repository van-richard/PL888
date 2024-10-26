#!/bin/bash

init="step3_pbcsetup_1264"
pmemd="pmemd.cuda"

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
#SBATCH -p bullet
#SBATCH -t 5-00:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=5G
#SBATCH --job-name=$(basename $(pwd))
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --gres=gpu:1

date

module load amber/23-gpu

$pmemd -O -i prod2.mdin \
    -p ${init}.parm7 \
    -c ${pstep}.rst7 \
    -o ${istep}.mdout \
    -r ${istep}.rst7 \
    -inf ${istep}.mdinfo \
    -ref ${init}.rst7 \
    -x ${istep}.nc

date

_EOF
