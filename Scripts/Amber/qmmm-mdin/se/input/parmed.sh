#!/bin/bash

module load ambertools23

init="step3_pbcsetup"

parmed -p ${init}.parm7 <<_EOF
loadRestrt ${init}.rst7
setOverwrite True
add12_6_4 :MG watermodel TIP3P
outparm ${init}_1264.parm7 ${init}_1264.rst7
_EOF
