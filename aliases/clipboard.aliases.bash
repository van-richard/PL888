#!/bin/bash
#
HOSTNAME=$(hostname)
if [ "${HOSTNAME}" == "lynnx" ]; then
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -seletion clipboard -o"
fi

