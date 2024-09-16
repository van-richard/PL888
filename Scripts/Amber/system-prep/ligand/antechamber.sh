#!/bin/bash

module load ambertools23

ligand=$1
charge_method="bcc"
verbose=2
net_charge=0
resname="lig"
intermediate_files="yes" # delete

if [ -z "${ligand}" ]; then
    echo "NOT FOUND: Requires the ligand PDB file!!!"
    exit 1
fi

if grep -q ".pdb" ${ligand}; then
    filename=$(awk -F "." '{print $1}')
    fileformat=$(awk -F "." '{print $1}')
else
    echo "Assuming PDB file"
    filename=${ligand}
    fileformat="pdb"
    name=$(echo ${ligand} | sed 's/.pdb//')
fi

antechamber \
    -i ${filename}.${fileformat} \
    -fi ${fileformat} \
    -o ${filename}.mol2 \
    -fo mol2 \
    -c ${charge_method} \
    -s ${verbose} \
    -nc ${net_charge} \
    -rn ${resfilename} \
    -pf ${intermediate_files}

if [ -f parmchk2.sh ] && [ ! -f "${filename}.frcmod" ]; then
    parmchk2 -i ${filename}.mol2 -f mol2 -o ${NAME}.frcmod
elif [ ! -f "parmchk2.sh" ] && [ ! -f "${filename}.frcmod" ]; then
    echo "NOT FOUND: parmchk2.sh - required for frcmod !!!"
else
    echo "Found frcmod file.. Skipping parmchk2."
fi

