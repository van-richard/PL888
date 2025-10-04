#!/bin/bash

vcp() {
    if [ $# -eq 0 ]; then
        echo "Usage: vcp <source> [destination]"
        return 1
    fi

    local src="$1"
    local dest="$2"

    if [ -z "$dest" ]; then
        # no destination given → copy into current directory
        command cp -v "$src" .
    else
        # use cp as normal
        command cp -v "$src" "$dest"
    fi
}
