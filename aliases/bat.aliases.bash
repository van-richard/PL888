#!/bin/bash


if [ -z $(which bat) ]; then
    echo "missing: bat !!!"
    exit 0
elif [ ! -z $(which batcat) ]; then
    echo "found: batcat !!!"
    alias cat="batcat"
fi

