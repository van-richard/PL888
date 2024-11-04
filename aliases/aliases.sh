#!/bin/bash

cwd=$(dirname ${BASH_SOURCE})

echo "
for a in $(ls ${cwd}/*.aliases.bash); do
    source $a
done
" >> ~/.bashrc
