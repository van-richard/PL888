#!/bin/bash
#

function wgetpdb () {
    local PDBID=$1
    wget https://files.rcsb.org/download/${PDBID}.pdb
}

function curlpdb () {
    local PDBID=$1
    curl -O https://files.rcsb.org/download/${PDBID}.pdb
}

