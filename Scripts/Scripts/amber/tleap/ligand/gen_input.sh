#!/bin/bash

shopt -s expand_aliases
source ~/.bash_aliases
mfa ambertools

# convert prmtop and inpcrd to pdb for antechamber / rename SOD CLA
reference="vmd-md-b"
cpptraj -p ${reference}.prmtop -y ${reference}.inpcrd -x ${reference}-traj.pdb

grep "UNK" ${reference}-traj.pdb > lig.pdb

./antechamber.sh lig.pdb

for i in protein ion water; do
    
    if [ "${i}" == "protein" ]; then
        cp ${reference}-traj.pdb ${i}.pdb
        sed -i "/UNK/d;/CLA/d;/SOD/d;/WAT/d" ${i}.pdb
        sed -i "s/HSD/HID/;s/HSE/HIE/;s/HSP/HIP/" ${i}.pdb

    elif [ "${i}" == "ion" ]; then
        egrep "CLA|SOD" ${reference}-traj.pdb > ${i}.pdb
        sed -i "s/CLA/Cl\-/g" ${i}.pdb
        sed -i "s/SOD/Na\+/g" ${i}.pdb

    elif [ "${i}" == "water" ]; then
        grep "WAT" ${reference}-traj.pdb > ${i}.pdb

    fi

done

