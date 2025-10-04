#!/bin/bash

if ! command -v squeue >/dev/null; then
    return
fi

alias q="squeue --format='%.12i %.10P %.14j %.8u %.12M %.10T %.4D  %R'"

function me () {
    local target="${1:-$USER}"
    q --user "$target"
}

