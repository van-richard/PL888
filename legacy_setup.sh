#!/bin/bash

_vlocal="$HOME/Programs"
_vgithub="$HOME/github"
_vtemplates="$_vgithub/PL888"
_vsetup="$_vtemplates/Setup"
_vmodules="$_vtemplates/modulefiles/modules.sh"
_vscripts="$_vtemplates/Scripts/bin"
bashrc="$(echo $HOME/.bashrc)"

printf "\nstarting $(realpath .)/setup.sh\n\n"

cat <<_EOF > tmp.bashrc
#!/bin/bash

if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -z "${PS1:-}" ]; then
    return # $PS1 not set, this is non-interactive shell
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
export _vgithub="$_vgithub"
export _vlocal="$_vlocal"
export _vsetup="$_vsetup"
export _vtemplates="$_vtemplates"
export _vmodules="$_vmodules"
export _vscripts="$_vscripts"
export bashrc="$vbashrc"

# configuration
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
n_diff=$(diff $bashrc tmp.bashrc --suppress-common-lines --brief | wc -l)
if [[ ${n_diff} -gt 0 ]]; then
    printf "\n\tsee diff? (y/n) "
    read yesdiff
    if [ "${yesdiff}" = "y" ]; then
        echo "------------------------------------------------------------------"
        diff $bashrc tmp.bashrc --suppress-common-lines
        echo "------------------------------------------------------------------"
    fi
    
    printf "replace with new changes? (y/n) "
    read yeschange
    if [ "${yeschange}" == "y" ]; then
        "adding: replace $bashrc with tmp.bashrc !!!"
        mv tmp.bashrc $bashrc
    else
        printf "\n\tskipping: add diff and deleting tmp.bashrc"
        rm tmp.bashrc
    fi
fi

printf "\n\tchecking: $HOME/.bashrc !!!"
if ! grep -q "source ${bashrc}" $HOME/.bashrc; then
    printf "\n\tadding: $bashrc to $HOME/.bashrc !!!"
    printf "\n\tsource ${bashrc}" >> $HOME/.bashrc
else
    printf "\n\tfound: $bashrc in $HOME/.bashrc !!!"
fi

printf "\nfinished: initialize new changes in current shell by running: \n"
printf "\nsource $HOME/.bashrc \n"

