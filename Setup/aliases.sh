#!/usr/bin/env bash

printf '%s\n' \
    'Warning: Setup/aliases.sh is deprecated.' \
    'Aliases are loaded by Profiles/bash/alias_loader.bash.' >&2

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    printf '%s\n' \
        'Source Profiles/bash/alias_loader.bash from an interactive Bash shell.' >&2
    exit 0
fi

_pl888_setup_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
_pl888_alias_loader="${_pl888_setup_dir}/../Profiles/bash/alias_loader.bash"

if [[ -f "$_pl888_alias_loader" ]]; then
    # shellcheck source=../Profiles/bash/alias_loader.bash
    . "$_pl888_alias_loader"
else
    printf 'Warning: alias loader not found: %s\n' "$_pl888_alias_loader" >&2
fi

unset _pl888_alias_loader _pl888_setup_dir
