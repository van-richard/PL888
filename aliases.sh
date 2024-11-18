#!/bin/bash

cwd=$(realpath $(dirname ${BASH_SOURCE[@]}))

for a in $(ls ${cwd}/aliases/*.aliases.bash); do
    source $a
done
