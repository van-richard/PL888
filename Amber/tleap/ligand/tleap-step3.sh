#!/bin/bash

PROTEIN="protein"
LIGAND="lig"
ION="ion"
WATER="water"

shopt -s expand_aliases
source ~/.bash_aliases
mfa ambertools

tleap -f -<<_EOF
source leaprc.protein.ff14SB
source leaprc.water.tip3p
source leaprc.gaff2

loadamberparams ${LIGAND}.frcmod
loadoff ${LIGAND}.lib

PROTEIN = loadpdb ${PROTEIN}.pdb
LIG = loadmol2 ${LIGAND}.mol2
ION = loadpdb ${ION}.pdb
WAT = loadpdb ${WATER}.pdb

SYS = combine { PROTEIN LIG ION WAT }

set SYS box { 82.0 82.0 82.0 }
check SYS

savepdb SYS step3_pbcsetup.pdb
saveamberparm SYS step3_pbcsetup.parm7 step3_pbcsetup.rst7

quit

_EOF
