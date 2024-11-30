#!/bin/bash


cmds=("bat" "batcat")

for cmd in "${cmds[@]}"; do
    if [ ! -z $(which ${cmd}) ]; then
        alias cat="${cmd}"
    fi
done 2>/dev/null



