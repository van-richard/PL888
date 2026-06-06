#!/bin/bash

#export _vlocal=$HOME/Programs
cmd="zoxide"


if ! compgen -c $cmd | grep -q "${cmd}"; then
    echo "downloading: zoxide !!!"

    mkdir -p ${_vlocal}/bin && cd ${_vlocal}/bin
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    
    echo "finished: run this !!!"
    echo "eval \$(zoxide init bash --cmd cd)"
fi

if ! grep "zoxide init bash" $HOME/.bashrc; then
    echo "missing: "
    echo "eval \$(zoxide init bash --cmd cd)" >> $HOME/.bashrc
fi
