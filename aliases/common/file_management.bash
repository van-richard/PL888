#!/usr/bin/env bash

_vchange_perms_usage() {
    printf 'Usage: vchange_perms [directory]\n'
}

vchange_perms() {
    local target="${1:-.}"
    local mode_dir=750
    local mode_file=640
    local dir=""
    local file=""

    case "${1:-}" in
        -h|--help)
            _vchange_perms_usage
            return 0
            ;;
    esac

    if [[ $# -gt 1 ]]; then
        _vchange_perms_usage >&2
        return 2
    fi

    if [[ ! -d "$target" ]]; then
        printf 'vchange_perms: not a directory: %s\n' "$target" >&2
        return 1
    fi

    printf 'Securing directory tree under: %s\n' "$target"
    printf '  Directories: %s\n' "$mode_dir"
    printf '  Files:       %s\n' "$mode_file"

    while IFS= read -r -d '' dir; do
        chmod "$mode_dir" "$dir" || return 1
    done < <(find "$target" -type d -print0)

    while IFS= read -r -d '' file; do
        chmod "$mode_file" "$file" || return 1
    done < <(find "$target" -type f -print0)

    printf 'Done.\n'
}
