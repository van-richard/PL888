#!/bin/bash

if ! command -v sbatch >/dev/null 2>&1; then
    return
fi

function vbatch () {
    local part
    local vpart
    local vexclude
    local xlist
    local dname="$(dirname $(realpath .))"
    local dirname="${1:${dname}}"


    if [ -f "/home/van/exclude.list" ]; then
        vexclude="--exclude=$(cat /home/van/exclude.list)"
    fi

    for partition in ${partitions[@]}; do
        if [ "${part}" == "${partition}" ]; then
            vpart="-p ${part}"
        fi
    done

    sbatch $vexclude -J ${dirname} ${@}
}


