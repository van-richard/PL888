#!/usr/bin/env bash
# FOR PUBLIC USE
# if you don't really care then source this file
#
# echo "source /path/to/this/file.sh" >> "$HOME/.bashrc"

if [[ -z "${PS1:-}" ]]; then
    # Keep non-interactive shells quiet. Exit safely if this file was executed.
    if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
        return 0
    fi
    exit 0
fi

export _vtemplates="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
export _vscripts="${_vtemplates}/Scripts/bin"
export _vlocal="${HOME}/.local"

if [[ -f "${HOME}/.vbashrc" ]]; then
    . "${HOME}/.vbashrc"
else
    printf 'Warning: %s is missing. Run ./setup.sh --apply from %s or source %s manually.\n' \
        "${HOME}/.vbashrc" "${_vtemplates}" \
        "${_vtemplates}/Profiles/bash/bashrc" >&2
fi

export PATH="${_vlocal}/bin:${_vscripts}:${PATH}"
