#!/bin/bash

vbashrc=$HOME/.vbashrc
cmd="fzf"

if [ ! -f $vbashrc ]; then
    echo "missing: $vbashrc !!!"
    exit 1
fi

if ! $(echo $PATH | grep -q "${_vlocal}/bin"); then
    echo "missing: $_vlocal !!!"
    echo "export PATH:\${_vlocal}/bin:\$PATH" >> $vbashrc
    source $vbashrc
fi

if ! compgen -c $cmd | grep -q "$cmd"; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ${_vlocal}/bin
    ${_vlocal}/bin/install
fi

echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> $vbashrc


