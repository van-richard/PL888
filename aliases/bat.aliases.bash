#!/bin/bash

base="/home/van/.local"
cmds=("bat" "batcat")

for cmd in "${cmds[@]}"; do
    if [ -f  "${_vlocal}/bin/${cmd}" ]; then
        alias cat="${base}/bin/${cmd}"
        source ${_vlocal}/autocomplete/${cmd}.bash
    fi
done 2>/dev/null

