#!/usr/bin/env bash

if [[ "${PL888_NO_BAT_ALIAS:-0}" == 1 ]]; then
    return 0 2>/dev/null || exit 0
fi

_pl888_bat_resolve() {
    local candidate=""
    local resolved=""

    if [[ -n "${PL888_BAT_COMMAND:-}" ]]; then
        if [[ -x "${PL888_BAT_COMMAND}" ]]; then
            printf '%s\n' "${PL888_BAT_COMMAND}"
        elif [[ "${PL888_DEBUG:-0}" == 1 ]]; then
            printf 'bat alias: PL888_BAT_COMMAND is not executable: %s\n' \
                "${PL888_BAT_COMMAND}" >&2
        fi
        return 0
    fi

    for candidate in bat batcat; do
        resolved="$(command -v "${candidate}" 2>/dev/null)" || continue
        case "${resolved}" in
            */*)
                printf '%s\n' "${resolved}"
                return 0
                ;;
        esac
        if [[ "${PL888_DEBUG:-0}" == 1 ]]; then
            printf 'bat alias: skipping non-executable resolution for %s: %s\n' \
                "${candidate}" "${resolved}" >&2
        fi
    done

    if [[ "${PL888_DEBUG:-0}" == 1 ]]; then
        printf 'bat alias: bat/batcat not found in PATH\n' >&2
    fi
    return 0
}

_pl888_bat_source_completion() {
    local command_name="$1"
    local completion_path=""
    local -a completion_candidates=(
        "${HOME}/.local/autocomplete/${command_name}.bash"
        "${HOME}/.config/bash_completion.d/${command_name}.bash"
        "/usr/share/bash-completion/completions/${command_name}"
        "/usr/share/bash-completion/completions/${command_name}.bash"
        "/etc/bash_completion.d/${command_name}"
    )

    for completion_path in "${completion_candidates[@]}"; do
        if [[ -r "${completion_path}" ]]; then
            . "${completion_path}"
            return 0
        fi
    done

    return 0
}

_pl888_bat_command="$(_pl888_bat_resolve)"
if [[ -n "${_pl888_bat_command}" ]]; then
    _pl888_bat_alias=""
    printf -v _pl888_bat_alias '%q' "${_pl888_bat_command}"
    alias cat="${_pl888_bat_alias}"

    if [[ "${_pl888_bat_command##*/}" == batcat ]]; then
        alias bat="${_pl888_bat_alias}"
    fi

    _pl888_bat_source_completion "${_pl888_bat_command##*/}"
fi

unset -f _pl888_bat_resolve _pl888_bat_source_completion
unset _pl888_bat_alias _pl888_bat_command
