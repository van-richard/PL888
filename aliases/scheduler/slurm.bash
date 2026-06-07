#!/usr/bin/env bash

_pl888_slurm_usage_me() {
    printf 'Usage: me [username] [extra-squeue-args...]\n'
}

_pl888_slurm_usage_vbatch() {
    printf 'Usage: vbatch [-h|--help] [sbatch-args ...]\n'
}

_pl888_slurm_has_job_name_option() {
    local arg=""

    for arg in "$@"; do
        case "${arg}" in
            -J|--job-name|-J*|--job-name=*)
                return 0
                ;;
        esac
    done

    return 1
}

sq() {
    if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
        printf 'Usage: sq [squeue-args...]\n'
        return 0
    fi

    if ! command -v squeue >/dev/null 2>&1; then
        printf 'sq: squeue not found in PATH\n' >&2
        return 1
    fi

    command squeue --format='%.12i %.10P %.14j %.8u %.12M %.10T %.4D  %R' "$@"
}

me() {
    local target="${USER:-}"
    local -a extra_args=()

    case "${1:-}" in
        -h|--help)
            _pl888_slurm_usage_me
            return 0
            ;;
    esac

    if [[ $# -gt 0 && "${1:-}" != -* ]]; then
        target="$1"
        shift
    fi

    extra_args=("$@")

    if [[ -z "${target}" ]]; then
        printf 'me: USER is not set\n' >&2
        return 1
    fi

    sq --user "$target" "${extra_args[@]}"
}

vbatch() {
    local dirname=""

    case "${1:-}" in
        -h|--help)
            _pl888_slurm_usage_vbatch
            return 0
            ;;
    esac

    if ! command -v sbatch >/dev/null 2>&1; then
        printf 'vbatch: sbatch not found in PATH\n' >&2
        return 1
    fi

    if _pl888_slurm_has_job_name_option "$@"; then
        command sbatch "$@"
        return $?
    fi

    dirname="$(basename -- "$PWD")"
    command sbatch -J "$dirname" "$@"
}
