#!/bin/bash
# Check if file exists
# INP can be file in current directory or path to file
# 

function checkfor () {
    local INPS="${@}"
    for INP in ${INPS[@]}; do
        if [ -e "${INP}" ]; then
            echo "Found: ${INP} !!!"
        else
            echo "Missing: ${INP} "
        fi
    done
}

