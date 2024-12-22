#!/bin/bash

base="/home/van/.local"
cmds=("bat" "batcat")

for cmd in "${cmds[@]}"; do
    if [ -f  "${base}/bin/${cmd}" ]; then
        alias cat="${base}/bin/${cmd}"
        source ${base}/share/autocomplete/${cmd}.bash
    fi
done 2>/dev/null

