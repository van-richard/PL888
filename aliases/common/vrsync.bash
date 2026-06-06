#!/usr/bin/env bash

_vrsync_remote_path() {
    local remote_path="$1"
    local remote_root="${VRSYNC_REMOTE_ROOT:-.}"

    case "$remote_path" in
        /*|~*)
            printf '%s\n' "$remote_path"
            ;;
        *)
            printf '%s/%s\n' "${remote_root%/}" "$remote_path"
            ;;
    esac
}

_vrsync_default_local_path() {
    local remote_path="${1%/}"
    local local_path="${remote_path##*/}"

    if [[ -z "$local_path" || "$local_path" == "." || "$local_path" == "~" ]]; then
        local_path="."
    fi
    printf '%s\n' "$local_path"
}

_vrsync_filter_args() {
    local preset="${VRSYNC_FILTER_PRESET:-amber-qmmm}"

    case "$preset" in
        amber-qmmm)
            printf '%s\n' \
                '--filter=include, **/step3_pbcsetup.parm7' \
                '--filter=include, **/step3_pbcsetup.rst7' \
                '--filter=include, **/step3_pbcsetup.ncrst' \
                '--filter=include, **/step3_pbcsetup_1264.parm7' \
                '--filter=include, **/step3_pbcsetup_1264.rst7' \
                '--filter=include, **/step3_pbcsetup_1264.ncrst' \
                '--filter=include, **/step3_pbcsetup_wat.pdb' \
                '--filter=include, **/input/**' \
                '--filter=exclude, **/*.slurm' \
                '--filter=exclude, **/*.sh' \
                '--filter=exclude, **/*.mdin' \
                '--filter=exclude, **/*.mdout' \
                '--filter=exclude, **/*.mdinfo' \
                '--filter=exclude, **/*.ncrst' \
                '--filter=exclude, **/*.rst7' \
                '--filter=exclude, **/step7*' \
                '--filter=exclude, **/qmhub/**' \
                '--filter=exclude, **/save/**' \
                '--filter=exclude, **/qmmm.inp_????' \
                '--filter=exclude, **/qmhub.squashfs' \
                '--filter=exclude, **/*.npy' \
                '--filter=exclude, **/sinrvels.rst' \
                '--filter=exclude, **/restrt'
            ;;
        none)
            ;;
        *)
            printf 'vrsync: unsupported VRSYNC_FILTER_PRESET: %s\n' \
                "$preset" >&2
            return 1
            ;;
    esac
}

vrsync() {
    local host=""
    local remote_path=""
    local local_path=""
    local remote_spec=""
    local temp_dir="${VRSYNC_TEMP_DIR:-/tmp}"
    local -a rsync_args=(
        --archive
        --compress
        --delete-before
        --delete-excluded
        --copy-links
        --human-readable
        --inplace
        --prune-empty-dirs
        --progress
        "--temp-dir=${temp_dir}"
    )
    local -a filter_args=()
    local -a extra_args=()

    case "$#" in
        0)
            read -r -e -p "Remote host or SSH alias: " host
            read -r -e -p "Remote path: " remote_path
            ;;
        1)
            if [[ "$1" == *:* ]]; then
                host="${1%%:*}"
                remote_path="${1#*:}"
            else
                # Backward-compatible form: vrsync HOST, then prompt for path.
                host="$1"
                read -r -e -p "Remote path: " remote_path
            fi
            ;;
        2)
            if [[ "$1" == *:* ]]; then
                host="${1%%:*}"
                remote_path="${1#*:}"
                local_path="$2"
            else
                host="$1"
                remote_path="$2"
            fi
            ;;
        3)
            host="$1"
            remote_path="$2"
            local_path="$3"
            ;;
        *)
            printf 'Usage: vrsync [host:]remote_path [local_path]\n' >&2
            printf '       vrsync host remote_path [local_path]\n' >&2
            return 2
            ;;
    esac

    if [[ -z "$host" ]]; then
        read -r -e -p "Remote host or SSH alias: " host
    fi
    if [[ -z "$remote_path" ]]; then
        read -r -e -p "Remote path: " remote_path
    fi
    if [[ -z "$host" || -z "$remote_path" ]]; then
        printf 'vrsync: host and remote path are required\n' >&2
        return 2
    fi

    remote_path="$(_vrsync_remote_path "$remote_path")"
    if [[ -z "$local_path" ]]; then
        local_path="$(_vrsync_default_local_path "$remote_path")"
    fi
    remote_spec="${host}:${remote_path%/}/"

    case "${VRSYNC_FILTER_PRESET:-amber-qmmm}" in
        amber-qmmm|none)
            ;;
        *)
            printf 'vrsync: unsupported VRSYNC_FILTER_PRESET: %s\n' \
                "${VRSYNC_FILTER_PRESET}" >&2
            return 2
            ;;
    esac

    while IFS= read -r filter_arg; do
        [[ -n "$filter_arg" ]] && filter_args+=("$filter_arg")
    done < <(_vrsync_filter_args)

    if [[ -n "${VRSYNC_RSYNC_OPTS:-}" ]]; then
        read -r -a extra_args <<< "$VRSYNC_RSYNC_OPTS"
    fi

    command rsync \
        "${rsync_args[@]}" \
        "${filter_args[@]}" \
        "${extra_args[@]}" \
        -e ssh \
        "$remote_spec" \
        "$local_path"
}

_vrsync_completion_hosts() {
    local -a hosts=()
    local -a configured_hosts=()
    local -a ssh_files=()
    local ssh_file
    local keyword
    local host
    local rest

    if [[ -n "${VRSYNC_HOSTS:-}" ]]; then
        read -r -a configured_hosts <<< "$VRSYNC_HOSTS"
        hosts+=("${configured_hosts[@]}")
    fi

    [[ -f "${HOME}/.ssh/config" ]] && ssh_files+=("${HOME}/.ssh/config")
    if [[ -d "${HOME}/.ssh/config.d" ]]; then
        while IFS= read -r ssh_file; do
            ssh_files+=("$ssh_file")
        done < <(
            find "${HOME}/.ssh/config.d" -maxdepth 1 -type f -print |
                LC_ALL=C sort
        )
    fi

    for ssh_file in "${ssh_files[@]}"; do
        while read -r keyword rest; do
            case "$keyword" in
                [Hh][Oo][Ss][Tt])
                    ;;
                *)
                    continue
                    ;;
            esac
            for host in $rest; do
                case "$host" in
                    *[\*\?\!]*)
                        ;;
                    *)
                        hosts+=("$host")
                        ;;
                esac
            done
        done < "$ssh_file"
    done

    printf '%s\n' "${hosts[@]}"
}

_vrsync_complete() {
    local current="${COMP_WORDS[COMP_CWORD]}"
    local -a hosts=()

    while IFS= read -r host; do
        [[ -n "$host" ]] && hosts+=("$host")
    done < <(_vrsync_completion_hosts)

    COMPREPLY=($(compgen -W "${hosts[*]}" -- "$current"))
}

complete -F _vrsync_complete vrsync
