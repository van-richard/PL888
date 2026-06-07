#!/usr/bin/env bash

_pl888_pbs_usage_vsub() {
    printf 'Usage: vsub [-h|--help] [qsub-args ...]\n'
}

_pl888_pbs_usage_vdel() {
    printf 'Usage: vdel <job-name>\n'
}

_pl888_pbs_has_job_name_option() {
    local arg=""

    for arg in "$@"; do
        case "${arg}" in
            -N|--job-name|-N*|--job-name=*)
                return 0
                ;;
        esac
    done

    return 1
}

vsub() {
    local dirname=""

    case "${1:-}" in
        -h|--help)
            _pl888_pbs_usage_vsub
            return 0
            ;;
    esac

    if ! command -v qsub >/dev/null 2>&1; then
        printf 'vsub: qsub not found in PATH\n' >&2
        return 1
    fi

    if _pl888_pbs_has_job_name_option "$@"; then
        command qsub "$@"
        return $?
    fi

    dirname="$(basename -- "$PWD")"
    command qsub -N "$dirname" "$@"
}

pbfree() {
    case "${1:-}" in
        -h|--help)
            printf 'Usage: pbfree\n'
            return 0
            ;;
    esac

    if ! command -v pbsnodes >/dev/null 2>&1; then
        printf 'pbfree: pbsnodes not found in PATH\n' >&2
        return 1
    fi

    command pbsnodes -avSj
}

vdel() {
    local jobname=""
    local -a jobs=()

    case "${1:-}" in
        -h|--help)
            _pl888_pbs_usage_vdel
            return 0
            ;;
    esac

    if [[ $# -ne 1 ]]; then
        _pl888_pbs_usage_vdel >&2
        return 2
    fi

    jobname="$1"

    if ! command -v qselect >/dev/null 2>&1; then
        printf 'vdel: qselect not found in PATH\n' >&2
        return 1
    fi
    if ! command -v qdel >/dev/null 2>&1; then
        printf 'vdel: qdel not found in PATH\n' >&2
        return 1
    fi

    mapfile -t jobs < <(command qselect -N "$jobname")
    if [[ ${#jobs[@]} -eq 0 ]]; then
        printf 'vdel: no jobs found for job name: %s\n' "$jobname" >&2
        return 1
    fi

    command qdel "${jobs[@]}"
}
