#!/bin/bash

bashrc=$HOME/.bashrc
cmd="fzf"


if ! compgen -c $cmd | grep -q "$cmd"; then
    echo "downloading: fzf !!!"
    git clone --depth 1 https://github.com/junegunn/fzf.git ${_vlocal}/bin
    ${_vlocal}/bin/install
fi

if ! grep -q "fzf" $HOME/.bashrc; then
    echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> $HOME/.bashrc
fi


unset bashrc
