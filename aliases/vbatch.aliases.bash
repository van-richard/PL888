#!/bin/bash

function vbatch () {
    local part
    local vpart
    local vexclude
    local xlist
    local dirname=$(dirname $(realpath .))

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


