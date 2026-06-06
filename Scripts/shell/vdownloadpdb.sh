#!/bin/bash

PDBID=${1}

if [ -z "${PDBID}" ]; then
    echo "Missing: PDB ID"
    exit 1
fi

if [ $(uname -m) == 'Linux' ]; then
    wget https://files.rcsb.org/download/${PDBID}.pdb
else
    curl -O https://files.rcsb.org/download/${PDBID}.pdb
fi
