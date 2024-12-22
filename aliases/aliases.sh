o#!/bin/bash

DIRNAME="$HOME/github/PL888/aliases"

for a in $(ls ${DIRNAME}/*.aliases.bash); do
    source $a
done
