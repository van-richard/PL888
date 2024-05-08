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

tleap -f -<<_EOF
source leaprc.protein.ff14SB
source leaprc.water.tip3p
source leaprc.gaff2

LIG = loadmol2 ${NAME}.mol2

check LIG

loadamberparams ${NAME}.frcmod
saveoff LIG ${NAME}.lib
saveamberparm LIG ${NAME}.parm7 ${NAME}.rst7

quit

_EOF
