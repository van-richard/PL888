#!/bin/bash

_vlocal="$HOME/.local"
_vgithub="$HOME/github"
_vtemplates="$_vgithub/PL888"
_vsetup="$_vtemplates/Setup"
_vmodules="$_vtemplates/modulefiles/modules.sh"
_vscripts="$_vtemplates/Scripts/bin"
vbashrc="$HOME/.vbashrc"

printf "\nstarting $(realpath .)/setup.sh\n\n"

cat <<_EOF > tmp.vbashrc
#!/bin/bash
# v's bash configuration file
#
# Since STDOUT from 'echo' breaks non-interactive sesssions...
#   $PS1 not set means this is most likely a non-interactive shell
if [ -z "${PS1:-}" ]; then
    return 
fi
# # ~/.bashrc: executed by bash(1) for non-login shells.
# # see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# # for examples
#  If not running interactively, don't do anything
# case $- in
#     *i*) ;;
#      *) return;;
# esac

# environment variables
export vbashrc="$vbashrc"
export _vgithub="$_vgithub"
export _vlocal="$_vlocal"
export _vsetup="$_vsetup"
export _vtemplates="$_vtemplates"
export _vmodules="$_vmodules"
export _vscripts="$_vscripts"

# configuration
umask 027
source \${_vmodules}
source \${_vtemplates}/Setup/aliases.sh
export PATH=\${_vlocal}/bin:\${_vscripts}:\${PATH}
_EOF

if [ ! -f "${vbashrc}" ]; then
    printf "\n\tmissing: $vbashrc !!!" 
else
    printf "\n\tfound: $vbashrc !!!" 
fi

# if different
n_diff=$(diff $vbashrc tmp.vbashrc --suppress-common-lines --brief | wc -l)
if [[ ${n_diff} -gt 0 ]]; then
    printf "\n\tsee diff? (y/n) "
    read yesdiff
    if [ "${yesdiff}" = "y" ]; then
        echo "------------------------------------------------------------------"
        diff $vbashrc tmp.vbashrc --suppress-common-lines
        echo "------------------------------------------------------------------"
    fi
    
    printf "replace with new changes? (y/n) "
    read yeschange
    if [ "${yeschange}" == "y" ]; then
        "adding: replace $vbashrc with tmp.vbashrc !!!"
        mv tmp.vbashrc $vbashrc
    else
        printf "\n\tskipping: add diff and deleting tmp.bashrc"
        rm tmp.vbashrc
    fi
fi

printf "\n\tchecking: $HOME/.bashrc !!!"
if ! grep -q "source ${vbashrc}" $HOME/.bashrc; then
    printf "\n\tadding: $vbashrc to $HOME/.bashrc !!!"
    printf "\n\tsource ${vbashrc}" >> $HOME/.bashrc
else
    printf "\n\tfound: $vbashrc in $HOME/.bashrc !!!"
fi

printf "\nfinished: initialize new changes in current shell by running: \n"
printf "\nsource $HOME/.bashrc \n"

