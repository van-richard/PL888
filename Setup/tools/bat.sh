#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: bat.sh [options]

Install bat into the configured local directory when bat is missing.

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

url="https://github.com/sharkdp/bat/releases/download/v0.24.0"
fname="bat-v0.24.0-i686-unknown-linux-musl"
cmd="bat"

if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "missing: bat !!!"
    
    wget "${url}/${fname}.tar.gz" -P /tmp
    tar xf "/tmp/${fname}.tar.gz" -C /tmp
    
    mkdir -p "${PL888_LOCAL_DIR}/bin"
    mv "/tmp/${fname}/bat" "${PL888_LOCAL_DIR}/bin"
    
    mkdir -p "${PL888_LOCAL_DIR}/autocomplete/bat"
    mv "/tmp/${fname}/autocomplete" "${PL888_LOCAL_DIR}/autocomplete/${cmd}"
fi

printf "\nadd one of the following to your ~/.bashrc file"
printf "\nalias cat='%s/bin/bat'" "${PL888_LOCAL_DIR}"
printf "\n\tor"
printf "\nexport PATH='%s/bin:\${PATH}'" "${PL888_LOCAL_DIR}"
printf "\nexport PATH='%s/share:\${PATH}'" "${PL888_LOCAL_DIR}"

rm -rf "/tmp/${fname}.tar.gz" "/tmp/${fname}"

unset url fname cmd
