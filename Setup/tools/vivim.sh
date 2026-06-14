#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: vivim.sh [options]

Create a ~/.vimrc from the repository Vim 7.4 variant when missing.

EOF
    pl888_setup_common_options
}

_setup_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
if [[ -f "${_setup_dir}/../lib/setup_paths.bash" ]]; then
    # shellcheck source=../lib/setup_paths.bash
    . "${_setup_dir}/../lib/setup_paths.bash"
elif [[ -f "${_setup_dir}/lib/setup_paths.bash" ]]; then
    # shellcheck source=../lib/setup_paths.bash
    . "${_setup_dir}/lib/setup_paths.bash"
else
    printf 'ERROR: setup path helper not found\n' >&2
    exit 1
fi
pl888_setup_resolve_paths "$@" || {
    usage >&2
    exit 2
}
if [[ "${PL888_SETUP_HELP}" == "1" ]]; then
    usage
    exit 0
fi
unset _setup_dir

vimrc="${PL888_HOME_DIR}/.vimrc"

if [[ ! -f "$vimrc" ]]; then
    echo "missing: $vimrc"
    echo "create one? (y/n)"
    read -r -e yesvim

    if [[ "${yesvim}" == "y" ]]; then
        cp "${PL888_REPO_ROOT}/Profiles/vim/variants/vimrc-7.4" "$vimrc"
    fi
fi
