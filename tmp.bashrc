#!/bin/bash

if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -z "" ]; then
    return #  not set, this is non-interactive shell
fi

# # ~/.bashrc: executed by bash(1) for non-login shells.
# # see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# # for examples
#  If not running interactively, don't do anything
# case hB in
#     *i*) ;;
#      *) return;;
# esac

# environment variables
export _vgithub="/home/van/github"
export _vlocal="/home/van/.local"
export _vsetup="/home/van/github/PL888/Setup"
export _vtemplates="/home/van/github/PL888"
export _vmodules="/home/van/github/PL888/modulefiles/modules.sh"
export _vscripts="/home/van/github/PL888/Scripts/bin"
export bashrc=""

# configuration
source ${_vmodules}
source ${_vtemplates}/Setup/aliases.sh
export PATH=${_vlocal}/bin:${_vscripts}:${PATH}
