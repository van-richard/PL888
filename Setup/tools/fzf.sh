#!/bin/bash

#export _vlocal=$HOME/Programs
bashrc=$HOME/.bashrc
cmd="fzf"

if ! compgen -c $cmd | grep -q "$cmd"; then
    echo "downloading: fzf !!!"
    cd ${_vlocal}/bin
    git clone --depth 1 https://github.com/junegunn/fzf.git 
    ./${cmd}/install
fi

if ! grep -q "fzf" $HOME/.bashrc; then
    echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> $HOME/.bashrc
fi


unset bashrc
