#!/bin/bash
# FOR PUBLIC USE
# if you don't really care then source this file
#
# echo "source /path/to/this/file.sh" >> $HOME/.bashrc

if [ -z "${PS1:-}" ]; then
    # Since STDOUT from 'echo' breaks non-interactive sesssions...
    #   $PS1 not set means this is most likely a non-interactive shell
    return 
fi

#NEW_ENV="/home/van/env.sh"
export _vmodules="/home/van/modulefiles/modules.sh"
export _vscripts="/home/van/Scripts/bin"
export _vlocal="/home/van/.local"
export _vtemplates="/scratch/van/PL888"

umask 027
source ${_vmodules}
source ${_vtemplates}/aliases/aliases.sh
export PATH=${_vlocal}/bin:${_vscripts}:${PATH}

