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

alias mfa="conda activate"
alias mfd="conda deactivate"

