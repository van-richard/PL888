#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: zoxide.sh [options]

Install zoxide into the configured local directory when zoxide is missing.

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

cmd="zoxide"
bashrc="${PL888_HOME_DIR}/.bashrc"

if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "downloading: zoxide !!!"

    mkdir -p "${PL888_LOCAL_DIR}/bin"
    cd "${PL888_LOCAL_DIR}/bin"
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    
    echo "finished: run this !!!"
    echo "eval \$(zoxide init bash --cmd cd)"
fi

if ! grep -q "zoxide init bash" "$bashrc"; then
    echo "missing: "
    echo "eval \$(zoxide init bash --cmd cd)" >> "$bashrc"
fi
