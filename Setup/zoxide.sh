#!/bin/bash

vbashrc=$HOME/.vbashrc
cmd="zoxide"

if [ ! -f $vbashrc ]; then
    echo "missing: $vbashrc !!!"
    exit 1
fi

if ! $(echo $PATH | grep -q "${_vlocal}/bin"); then
    echo "missing: $_vlocal !!!"
    echo "export PATH:\${_vlocal}/bin:\$PATH" >> $vbashrc
    source $vbashrc
fi

if ! compgen -c $cmd | grep -q "${cmd}"; then
    echo "downloading: zoxide !!!"

    mkdir -p ${_vlocal}/bin && cd ${_vlocal}/bin

    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    echo "export PATH:${_vlocal}/bin:\$PATH" >> $vbashrc
    echo "eval \$(zoxide init bash --cmd cd)" >> $vbashrc
fi

echo "run: "
echo "source $vbashrc"
