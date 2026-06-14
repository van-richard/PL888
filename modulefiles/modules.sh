#!/usr/bin/env bash
# Compatibility wrapper. Prefer sourcing set_modules.sh directly.

_modules_is_sourced() {
    [[ "${BASH_SOURCE[0]}" != "$0" ]]
}

_modules_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
_set_modules="${_modules_dir}/set_modules.sh"

if [[ ! -f "$_set_modules" ]]; then
    printf 'Warning: module loader not found: %s\n' "$_set_modules" >&2
    if _modules_is_sourced; then
        return 1
    fi
    exit 1
fi

# shellcheck disable=SC1090,SC1091
. "$_set_modules"

_machine="${MACHINE:-$(hostname -s)}"
case "$_machine" in
    lynnx|pete|oscer|hpcc)
        set_modules "$_machine"
        ;;
    *)
        printf 'Warning: no PL888 modulefile site selected for host %s.\n' \
            "$_machine" >&2
        ;;
esac

unset _machine _modules_dir _set_modules
