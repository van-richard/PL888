#!/bin/bash

cmds=("bat" "batcat")

for cmd in "${cmds[@]}"; do
    if [ -f  "${HOME}/.local/bin/${cmd}" ]; then
        alias cat="${HOME}/.local/bin/${cmd}"
        source ${HOME}/.local/autocomplete/${cmd}.bash
    fi
done 2>/dev/null

