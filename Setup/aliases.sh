#!/bin/bash

vbashrc=$HOME/.vbashrc

if [ ! -f $vbashrc ]; then
    echo "missing: $vbashrc !!!"
    exit 1
fi

if ! $(echo $PATH | grep -q "${_vlocal}/bin"); then
    echo "missing: $_vlocal !!!"
    echo "export PATH:\${_vlocal}/bin:\$PATH" >> $vbashrc
    source $vbashrc
fi

base="${_vtemplates}/aliases"
aliases=( $( ls ${base}/*.aliases.bash) )

for a in ${aliases[@]}; do
    source $a
done

unset base aliases
