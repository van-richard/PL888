#!/bin/bash
#
#
#

PROGRAMS="${HOME}/Programs"
MF="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname -s)-$(uname -m).sh"

mkdir -p $PROGRAMS
cd $PROGRAMS

wget ${MF}
$SHELL Miniforge3-$(uname -s)-$(uname -m).sh -p ${PROGRAMS}/miniforge3 -b -f -u -t

