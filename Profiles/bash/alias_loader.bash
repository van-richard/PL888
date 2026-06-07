#!/usr/bin/env bash

# This file is intended to be sourced by an interactive Bash shell.
if [[ -z "${BASH_VERSION:-}" || $- != *i* ]]; then
    return 0 2>/dev/null || exit 0
fi

if [[ "${PL888_NO_ALIASES:-0}" == "1" ]]; then
    return 0
fi

if [[ "${_PL888_ALIASES_LOADED:-0}" == "1" ]]; then
    return 0
fi
_PL888_ALIASES_LOADED=1

_pl888_alias_loader_dir="$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P
)"
_pl888_root="$(cd -- "${_pl888_alias_loader_dir}/../.." && pwd -P)"
_pl888_alias_root="${_pl888_root}/aliases"

_pl888_source_alias_file() {
    local alias_file="$1"

    [[ -f "$alias_file" ]] || return 0
    if [[ "${PL888_DEBUG:-0}" == "1" ]]; then
        printf 'PL888 aliases: loading %s\n' "$alias_file" >&2
    fi
    # shellcheck source=/dev/null
    . "$alias_file"
}

_pl888_load_alias_directory() {
    local alias_dir="$1"
    local alias_file

    [[ -d "$alias_dir" ]] || return 0
    while IFS= read -r alias_file; do
        _pl888_source_alias_file "$alias_file"
    done < <(
        find "$alias_dir" -maxdepth 1 -type f -name '*.bash' -print |
            LC_ALL=C sort
    )
}

_pl888_load_alias_directory "${_pl888_alias_root}/common"

_pl888_load_pbs_aliases=0
_pl888_load_slurm_aliases=0
case "$(uname -s 2>/dev/null || true)" in
    Linux)
        _pl888_source_alias_file "${_pl888_alias_root}/os/linux.bash"
        if command -v qsub >/dev/null 2>&1; then
            _pl888_load_pbs_aliases=1
        elif [[ "${PL888_DEBUG:-0}" == "1" ]]; then
            printf 'PL888 aliases: skipping PBS aliases (qsub not found)\n' >&2
        fi
        if command -v sbatch >/dev/null 2>&1 || command -v squeue >/dev/null 2>&1; then
            _pl888_load_slurm_aliases=1
        elif [[ "${PL888_DEBUG:-0}" == "1" ]]; then
            printf 'PL888 aliases: skipping SLURM aliases (sbatch/squeue not found)\n' >&2
        fi
        ;;
    Darwin)
        _pl888_source_alias_file "${_pl888_alias_root}/os/macos.bash"
        if [[ "${PL888_DEBUG:-0}" == "1" ]]; then
            printf 'PL888 aliases: skipping PBS aliases (non-Linux)\n' >&2
            printf 'PL888 aliases: skipping SLURM aliases (non-Linux)\n' >&2
        fi
        ;;
    *)
        if [[ "${PL888_DEBUG:-0}" == "1" ]]; then
            printf 'PL888 aliases: skipping PBS aliases (non-Linux)\n' >&2
            printf 'PL888 aliases: skipping SLURM aliases (non-Linux)\n' >&2
        fi
        ;;
esac

case "${PL888_SITE:-}" in
    pete|oscer|lynnx|local)
        _pl888_source_alias_file \
            "${_pl888_alias_root}/hpc/${PL888_SITE}.bash"
        ;;
    "")
        ;;
    *)
        printf 'Warning: unsupported PL888_SITE=%s; skipping site aliases.\n' \
            "$PL888_SITE" >&2
        ;;
esac

if [[ "${_pl888_load_pbs_aliases:-0}" == "1" ]]; then
    if [[ "${PL888_DEBUG:-0}" == "1" ]]; then
        printf 'PL888 aliases: loading PBS aliases\n' >&2
    fi
    _pl888_source_alias_file "${_pl888_alias_root}/scheduler/pbs.bash"
fi

if [[ "${_pl888_load_slurm_aliases:-0}" == "1" ]]; then
    if [[ "${PL888_DEBUG:-0}" == "1" ]]; then
        printf 'PL888 aliases: loading SLURM aliases\n' >&2
    fi
    _pl888_source_alias_file "${_pl888_alias_root}/scheduler/slurm.bash"
fi

_pl888_short_hostname="$(hostname -s 2>/dev/null || hostname 2>/dev/null || true)"
if [[ -n "$_pl888_short_hostname" ]]; then
    _pl888_source_alias_file \
        "${_pl888_alias_root}/host/${_pl888_short_hostname}.bash"
fi

_pl888_source_alias_file "${HOME}/.config/pl888/aliases.bash"

unset _pl888_short_hostname _pl888_alias_root _pl888_root
unset _pl888_alias_loader_dir
unset _pl888_load_pbs_aliases
unset _pl888_load_slurm_aliases
unset -f _pl888_load_alias_directory _pl888_source_alias_file
