#!/bin/bash

function rsync-local () {
    local SRC=$1
    local DST=$2
    checkfor $SRC $DST
    rsync -avuimP ${SRC} ${DST}
}

function rsync-ssh () {
    local HPC=$1
    local SRC=$2
    local DST=$3
    rsync -avuimPe 'ssh' ${HPC}:${SRC} ${DST}
}


function rsync-parallel () {
    local SRC=$1
    local DST=$2
    local PART=$(sinfo  --format "%R %l" --sort -l | tail -n 1 | awk '{print $1}')

sbatch <<_EOF
#!/bin/bash
#SBATCH -p ${PART}
#SBATCH -t 00:30:00
#SBATCH -n 32
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH -J nsync

# quickly sync hella directories

date

module load parallel

find $SRC -maxdepth 2 -type d | parallel -j $SLURM_NTASKS -X \
    rsync -aHRdmui "${SRC}/" "${DST}"

#parallel -j $SLURM_NTASKS -X \
#    rsync -avuim ${SRC}/ ${DEST}

date
_EOF
}
