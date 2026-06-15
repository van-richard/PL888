#!/usr/bin/env bash

# OSU Pete uses SLURM. Shared SLURM helpers are loaded from
# aliases/scheduler/slurm.bash when sbatch or squeue is available.

_osu_partition_exists() {
    local partition="$1"

    if ! command -v sinfo >/dev/null 2>&1; then
        printf 'missing: sinfo\n' >&2
        return 1
    fi

    sinfo -h -o "%P" | sed 's/[*]$//' | grep -Fxq -- "$partition"
}

_osu_require_partition() {
    local partition="$1"

    if _osu_partition_exists "$partition"; then
        return 0
    fi

    printf "Error: Partition '%s' does not exist.\n" "$partition" >&2
    printf 'Available partitions are:\n' >&2
    sinfo -h -o "%P" | sed 's/[*]$//' | sort -u >&2
    return 1
}

_osu_srun_shell() {
    local partition="$1"
    local ntasks="$2"
    local mem="$3"
    local time_limit="$4"
    local gres="${5:-}"
    local job_name="${6:-}"
    local -a srun_args=(
        --pty
        -p "$partition"
        -N 1
        --ntasks="$ntasks"
        --mem="$mem"
        --time="$time_limit"
    )

    if [[ -n "$job_name" ]]; then
        srun_args+=(-J "$job_name")
    fi
    if [[ -n "$gres" ]]; then
        srun_args+=(--gres="$gres")
    fi

    command srun "${srun_args[@]}" /bin/bash
}

batch() {
    _osu_srun_shell batch 32 20G 12:00:00
}

bigmem() {
    _osu_srun_shell bigmem 16 8G 12:00:00
}

bullet() {
    _osu_srun_shell bullet 16 8G 12:00:00 gpu:1
}

express() {
    _osu_srun_shell express 16 8G 01:00:00
}
