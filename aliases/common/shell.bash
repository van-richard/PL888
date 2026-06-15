#!/usr/bin/env bash

_vchange_shell_usage() {
    printf 'Usage: vchange_shell\n'
}

vchange_shell() {
    local new_shell=""
    local confirm=""

    case "${1:-}" in
        -h|--help)
            _vchange_shell_usage
            return 0
            ;;
    esac

    if [[ $# -gt 0 ]]; then
        _vchange_shell_usage >&2
        return 2
    fi

    if [[ ! -r /etc/shells ]]; then
        printf 'vchange_shell: cannot read /etc/shells\n' >&2
        return 1
    fi

    cat /etc/shells

    read -r -p "Change current shell to: " new_shell || return 1
    if [[ -z "$new_shell" ]]; then
        printf 'vchange_shell: shell path is required\n' >&2
        return 2
    fi

    if ! grep -Fxq -- "$new_shell" /etc/shells; then
        printf 'vchange_shell: %s is not listed in /etc/shells\n' \
            "$new_shell" >&2
        return 2
    fi

    read -r -p "Continue? (y/n): " confirm || return 1
    case "$confirm" in
        [yY]|[yY][eE][sS])
            command chsh -s "$new_shell"
            ;;
        *)
            printf 'vchange_shell: canceled\n' >&2
            return 1
            ;;
    esac
}
