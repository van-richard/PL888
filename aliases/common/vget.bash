#!/usr/bin/env bash

_vget_usage() {
    printf 'Usage: vget [pdb <pdbid> [outdir] | url <url> [outdir] | -h | --help]\n'
}

_vget_error_usage() {
    _vget_usage >&2
}

_vget_resolve_downloader() {
    local requested="${PL888_VGET_DOWNLOADER:-}"
    local downloader=""
    local resolved=""

    if [[ -n "${requested}" ]]; then
        case "${requested}" in
            wget|curl)
                downloader="${requested}"
                ;;
            *)
                printf 'vget: unsupported PL888_VGET_DOWNLOADER: %s\n' \
                    "${requested}" >&2
                return 1
                ;;
        esac

        resolved="$(command -v "${downloader}" 2>/dev/null)" || {
            printf 'vget: requested downloader not found: %s\n' \
                "${downloader}" >&2
            return 1
        }
        printf '%s\n' "${resolved}"
        return 0
    fi

    for downloader in wget curl; do
        resolved="$(command -v "${downloader}" 2>/dev/null)" || continue
        if [[ -n "${resolved}" ]]; then
            printf '%s\n' "${resolved}"
            return 0
        fi
    done

    printf 'vget: no downloader found (need wget or curl)\n' >&2
    return 1
}

_vget_download() {
    local downloader="$1"
    local url="$2"
    local outdir="${3:-}"
    local -a cmd=()

    case "${downloader##*/}" in
        wget)
            cmd=("${downloader}")
            if [[ -n "${outdir}" ]]; then
                mkdir -p -- "${outdir}" || return 1
                cmd+=(-P "${outdir}")
            fi
            cmd+=("${url}")
            command "${cmd[@]}"
            ;;
        curl)
            if [[ -n "${outdir}" ]]; then
                mkdir -p -- "${outdir}" || return 1
                (
                    cd -- "${outdir}" || exit 1
                    command "${downloader}" -fLO "${url}"
                )
            else
                command "${downloader}" -fLO "${url}"
            fi
            ;;
        *)
            printf 'vget: unsupported downloader executable: %s\n' \
                "${downloader}" >&2
            return 1
            ;;
    esac
}

vget() {
    local mode=""
    local value=""
    local outdir=""
    local pdbid=""
    local url=""
    local downloader=""

    case "${1:-}" in
        -h|--help)
            _vget_usage
            return 0
            ;;
    esac

    case "${1:-}" in
        pdb|url)
            mode="$1"
            shift
            ;;
        *)
            _vget_error_usage
            return 2
            ;;
    esac

    case "$#" in
        1)
            value="$1"
            ;;
        2)
            value="$1"
            outdir="$2"
            ;;
        *)
            _vget_error_usage
            return 2
            ;;
    esac

    if [[ -z "${value}" ]]; then
        printf 'vget: missing %s\n' "${mode}" >&2
        return 2
    fi

    case "${mode}" in
        pdb)
            pdbid="${value}"
            pdbid="$(printf '%s' "${pdbid}" | tr '[:upper:]' '[:lower:]')"
            url="https://files.rcsb.org/download/${pdbid}.pdb"
            ;;
        url)
            url="${value}"
            ;;
    esac

    downloader="$(_vget_resolve_downloader)" || return 1
    _vget_download "${downloader}" "${url}" "${outdir}"
}

if command -v complete >/dev/null 2>&1; then
    complete -W "pdb url" vget
fi
