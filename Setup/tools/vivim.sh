#!/bin/bash

vimrc=$HOME/.vimrc

if [ ! -f $vimrc ]; then
    echo "missing: $vimrc"
    echo "create one? (y/n)"
    read -e yesvim

    if [ ${yesvim} == 'y' ]; then
        cp ${_vtemplates}/Profiles/vim/variants/vimrc-7.4 $vimrc
    fi
fi
