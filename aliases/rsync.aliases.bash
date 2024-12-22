#!/bin/bash

opts="ssh mpi"
sshopt="osu ou"

function vsync () {
    local ssh
    local mpi

    vreplys="rsync --archive --itemize-changes --delete --progress --update --verbose ${@}"

    if [ "${2}" == "ssh" ]; then
        complete -W "${sshopt}" $2
        #${vreply} -e 'ssh' ${@}

    elif "${2}" == "mpi" ]; then
        local SRC
        if [ -z "${SRC}" ]; then
            echo "missing: source directory path"
        else
            find ${SRC} -type f | parallel -j 4 -X ${vreply} --hard-links --relative "$SRC" ${@}
        fi
    fi

}

complete -W "${opts}" vsync

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
