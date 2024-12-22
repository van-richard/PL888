#!/bin/bash

DIRNAME=$(dirname "${BASH_SOURCE}")

for a in $(ls ${DIRNAME}/*.aliases.bash); do
    source $a
done
