#!/bin/bash
function DL-miniforge3 () {
    local PROGDIR="$HOME/Programs"
    local _mf="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname -s)-$(uname -m).sh"
    mkdir -p $PROGDIR
    cd $PROGDIR
    wget $_mf
    $SHELL Miniforge3-$(uname -s)-$(uname -m).sh -b -f -u -t
}

function mf () {
    local diropts=("${HOME}" "/scratch/${USER}")
    local program="Programs"
    local dirname="miniforge3"
    local log="/tmp/$USER-check-conda.txt"
    local n_dirs=0
    local condabase

    touch $log
    
    for opt in ${diropts[@]}; do
        local base="${opt}/${program}/${dirname}"

        #echo "searching: ${base}" 
        if [ -d "${base}" ]; then
            echo ${base} > $log
        fi
    done
        
    n_dirs=$(cat $log | wc -l)

    if [[ ${n_dirs} -gt 1 ]]; then
        echo "found: ${n_dirs} conda directories"
    elif [[ ${n_dirs} -lt 1 ]]; then
        echo "missing: miniforge install !!!"
    else
        condabase=$(cat $log)
    fi

    source $condabase/bin/activate
}


function mfa () {
    local env

    conda activate $env
}

function mfd () {
    conda deactivate
}


complete -W "create remove" mf
