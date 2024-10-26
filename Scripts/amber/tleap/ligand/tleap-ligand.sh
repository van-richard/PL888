#!/bin/bash

module load ambertools23

fname=$1

if [ -z "${fname}" ]; then
    echo "NOT FOUND: PDB file of ligand!!!"
    exit 1
fi

if grep -q ".mol2" ${fname}; then
    filename=$(awk -F '.' '{print $1}')
    fileformat=$(awk -F '.' '{print $2}')
elif grep -q ".pdb" ${fname}; then
    echo "Please run antechamber to generate a mol2 file !!!"
    exit 1
else
    echo "Assuming PDB file format..."
    filename=${fname}
    fileformat="mol2"
fi

tleap -f -<<_EOF
source leaprc.protein.ff14SB
source leaprc.water.tip3p
source leaprc.gaff2

LIG = loadmol2 ${filename}.${fileformat}

check LIG

loadamberparams ${filename}.frcmod
saveoff LIG ${NAME}.lib
saveamberparm LIG ${NAME}.parm7 ${NAME}.rst7

quit

_EOF
