#!/bin/bash

source check.aliases.bash

function rsyncf () {
    # local rsync 
    rsyncf --archive --itemize-changes --delete --progress --update --verbose ${@}
}

function rsyncssh () {
    # server-client rsync
    rsyncf -e 'ssh' ${@}
}


function rsyncp () {
    local SRC=$1
    find ${SRC} -type f | parallel -j 4 -X rsyncf --hard-links --relative \
        "$SRC" ${@}
}

# sbatch <<_EOF
# #!/bin/bash
# #SBATCH -p ${PART}
# #SBATCH -t 00:30:00
# #SBATCH -n 32
# #SBATCH -o %j.out
# #SBATCH -e %j.err
# #SBATCH -J nsync
# 
# # quickly sync hella directories
# 
# date
# 
# module load parallel
# 
# find $SRC -maxdepth 2 -type d | parallel -j $SLURM_NTASKS -X \
#     rsync -aHRdmui "${SRC}/" "${DST}"
# 
# #parallel -j $SLURM_NTASKS -X \
# #    rsync -avuim ${SRC}/ ${DEST}
# 
# date
# _EOF
#
