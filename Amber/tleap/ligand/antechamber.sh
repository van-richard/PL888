#!/bin/bash

LIGAND=$1
CHARGE_METHOD="bcc"
VERBOSE=2
NET_CHARGE=0
RESNAME="LIG"
INTERMEDIATE_FILES="yes" # delete

if [ -z "${LIGAND}" ]; then
    echo "Need a PDB file!!!"
    exit 1
else
    NAME=$(echo ${LIGAND} | sed 's/.pdb//')
fi

shopt -s expand_aliases
source ~/.bash_aliases
mfa ambertools

antechamber \
    -i ${NAME}.pdb \
    -fi pdb \
    -o ${NAME}.mol2 \
    -fo mol2 \
    -c ${CHARGE_METHOD} \
    -s ${VERBOSE} \
    -nc ${NET_CHARGE} \
    -rn ${RESNAME} \
    -pf ${INTERMEDIATE_FILES}

if [ ! -f "${NAME}.frcmod" ]; then
    parmchk2 -i ${NAME}.mol2 -f mol2 -o ${NAME}.frcmod
else
    echo "Found frcmod file.. Skipping parmchk2."
fi

