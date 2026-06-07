#!/bin/bash

_vcp_usage() {
    printf 'Usage: vcp [cp-options] [--] source [destination ...]\n'
    printf '       vcp -h | --help\n'
}

vcp() {
    local -a opts=()
    local -a operands=()
    local arg=""

    while [[ $# -gt 0 ]]; do
        arg="$1"
        case "${arg}" in
            -h|--help)
                _vcp_usage
                return 0
                ;;
            --)
                shift
                break
                ;;
            -*)
                opts+=("${arg}")
                shift
                ;;
            *)
                break
                ;;
        esac
    done

    while [[ $# -gt 0 ]]; do
        operands+=("$1")
        shift
    done

    if [[ ${#operands[@]} -eq 0 ]]; then
        _vcp_usage >&2
        return 1
    fi

    if [[ ${#operands[@]} -eq 1 ]]; then
        command cp -v "${opts[@]}" -- "${operands[0]}" .
        return $?
    fi

    command cp -v "${opts[@]}" -- "${operands[@]}"
}
