#!/bin/bash
# Prepare topology/coordinate files 
# For protein, nucleic acid, and metal ion containing systems
# To add 12-6-4 LJ parameters, run:
#   bash parmed.sh

SYS=$1 # FILENAME.pdb

module load ambertools23

tleap -f -<<_EOF
source leaprc.protein.ff14SB
source leaprc.DNA.OL15
source leaprc.RNA.OL3
source leaprc.water.tip3p 
loadamberparams frcmod.ions234lm_1264_tip3p 

sys = loadpdb ${SYS}

savepdb sys step3_pbcsetup.pdb
charge sys
setbox sys vdw 

saveamberparm sys step3_pbcsetup.parm7 step3_pbcsetup.ncrst
savepdb sys step3_pbcsetup_wat.pdb

quit

_EOF