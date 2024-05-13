#!/bin/bash

LIGAND=$1

if [ -z "${LIGAND}" ]; then
    echo "Need a PDB file!!!"
    exit 1
else
    NAME=$(echo ${LIGAND} | sed 's/.pdb//')
fi

shopt -s expand_aliases
source ~/.bash_aliases
mfa ambertools

if [ ! -f "${NAME}.frcmod" ]; then
    parmchk2 -i ${NAME}.mol2 -f mol2 -o ${NAME}.frcmod
else
    echo "Found frcmod file.. Skipping parmchk2."
fi

