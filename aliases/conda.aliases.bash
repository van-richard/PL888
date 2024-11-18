#!/bin/bash
#
#


function DL-miniforge3 () {
    local PROGDIR="$HOME/Programs"
    local _mf="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname -s)-$(uname -m).sh"
    mkdir -p $PROGDIR
    cd $PROGDIR
    wget $_mf
    $SHELL Miniforge3-$(uname -s)-$(uname -m).sh -b -f -u -t
}

function mf () {
    local MF="${HOME}/Programs/miniforge3"
    local uMF=${1}
    if [ ! -d $MF ]; then
        echo "missing: ${MF}"
        echo "try passing the path to your miniforge as the first arg"
        echo ""
        exit 0
    elif [ -d $MF ]; then
        echo "found: ${MF}"
        source ${MF}/bin/activate
    elif [ ! -z ${uMF} ] && [ -d ${uMF} ]; then 
        echo "found: ${uMF}"
        source ${MF}/bin/activate
        echo "found: ${uMF}"
    fi
}


alias mfa="conda activate"
alias mfd="conda deactivate"

