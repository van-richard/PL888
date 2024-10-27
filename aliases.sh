#!/bin/bash

cwd=$(dirname ${BASH_SOURCE[@]})

for a in $(ls ${cwd}/aliases/*.aliases.bash); do
    source $a
done
