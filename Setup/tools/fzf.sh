#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: fzf.sh [options]

Install fzf under the configured local directory when fzf is missing.

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

bashrc="${PL888_HOME_DIR}/.bashrc"
cmd="fzf"

if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "downloading: fzf !!!"
    mkdir -p "${PL888_LOCAL_DIR}/bin"
    cd "${PL888_LOCAL_DIR}/bin"
    git clone --depth 1 https://github.com/junegunn/fzf.git 
    ./${cmd}/install
fi

if ! grep -q "fzf" "$bashrc"; then
    echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> "$bashrc"
fi


unset bashrc cmd
