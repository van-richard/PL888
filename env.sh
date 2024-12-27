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
#export _vmodules="$HOME/modulefiles/modules.sh"
export _vtemplates="$HOME/Github/PL888"
export _vscripts="$HOME/Scripts/bin"
export _vlocal="$HOME/.local"

#umask 027
#source ${_vmodules}

if [ -f ~/.vbashrc ]; then
    . ~/.vbashrc
else
    bash ${_vtemplates}/Setup/aliases.sh
    . ~/.vbashrc
fi

export PATH=${_vlocal}/bin:${_vscripts}:${PATH}

