#!/bin/bash


function _vrsync_host () {
    local opts=${@}
    local vhost
    local ssh

    if [ -f ~/.ssh/config ]; then
        export vhostnames=( $(cat ~/.ssh/config | sed -r "/\*/d;/HostName/d;/Strict/d" | grep Host | awk '{print $2}') )
    fi


    for opt in ${opts[@]}; do
        if echo ${vhostnames} | grep -q "${opt}"; then
            ssh=${opt}
            echo $vhost
        else
            printf "\nenter USERNAME@SERVER or host alias: "
            read ssh
        fi
    done

        
    echo $ssh
}

function vrsync () {
    local ssh="osu"
    local srcdir="/scratch/van"
    local dirname

    printf "\nenter path to local directory (assumes ${srcdir}): "
    read -e dirname


    rsync \
        --archive \
        --compress \
        --delete-before \
        --delete-excluded \
        --copy-links \
        --human-readable \
        --inplace \
        --prune-empty-dirs \
        --progress \
        --temp-dir=/tmp \
        --filter "include, **/step3_pbcsetup.parm7" \
        --filter "include, **/step3_pbcsetup.rst7" \
        --filter "include, **/step3_pbcsetup.ncrst" \
        --filter "include, **/step3_pbcsetup_1264.parm7" \
        --filter "include, **/step3_pbcsetup_1264.rst7" \
        --filter "include, **/step3_pbcsetup_1264.ncrst" \
        --filter "include, **/step3_pbcsetup_wat.pdb" \
        --filter "include, **/input/**" \
        --filter "exclude, **/*.slurm" \
        --filter "exclude, **/*.sh" \
        --filter "exclude, **/*.mdin" \
        --filter "exclude, **/*.mdout" \
        --filter "exclude, **/*.mdinfo" \
        --filter "exclude, **/*.ncrst" \
        --filter "exclude, **/*.rst7" \
        --filter "exclude, **/step7*" \
        --filter "exclude, **/qmhub/**" \
        --filter "exclude, **/save/**" \
        --filter "exclude, **/qmmm.inp_????" \
        --filter "exclude, **/qmhub.squashfs" \
        --filter "exclude, **/*.npy" \
        --filter "exclude, **/sinrvels.rst" \
        --filter "exclude, **/restrt" \
        -e 'ssh' ${ssh}:${srcdir}/${dirname}/ ${dirname} 

    unset _V_SSH
}
