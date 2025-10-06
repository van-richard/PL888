#!/bin/bash
# shellcheck shell=bash
# Defines `set_modules` and optional CLI.
# Why: Safe to source in rc files without killing the shell.

__sm_is_sourced() { [[ "${BASH_SOURCE[0]}" != "$0" ]]; }

_sm_valid() {
  case "${1:-}" in
    lynnx|pete|oscer) return 0 ;;
    *) return 1 ;;
  esac
}

_sm_have_module() {
  # Works for both Tcl Modules and Lmod after their init script is sourced.
  type module &>/dev/null
}

_sm_find_machine_module_dir() {
  # Prefer ~/modulefiles/<MACHINE>, fallback to ~/modulesfiles/<MACHINE>.
  local m="$1" d
  for d in "/home/van/modulefiles/$m"; do
    [[ -d "$d" ]] && { printf '%s\n' "$d"; return 0; }
  done
  return 1
}

_sm_unuse_all_user_machine_dirs() {
  # Avoid path bloat when switching machines repeatedly.
  local base d
  for base in "/home/van/modulesfiles/$m"; do
    [[ -d "$base" ]] || continue
    # Only unuse direct subdirs (machine buckets).
    for d in "$base"/*; do
      [[ -d "$d" ]] || continue
      module unuse "$d" >/dev/null 2>&1 || true
    done
  done
}

sm_apply_modulepath() {
  # Why: Keep MODULEPATH aligned with $MACHINE across interactive & non-interactive shells.
  local m="$1" path
  _sm_have_module || return 0
  _sm_unuse_all_user_machine_dirs
  if path="$(_sm_find_machine_module_dir "$m")"; then
    module use "$path"   # prepends path; idempotent if re-run
  else
    printf "Warning: no modulefiles dir for '%s' under ~/modulefiles or ~/modulesfiles\n" "$m" >&2
  fi
}

set_modules() {
  local arg="${1:-${MACHINE:-}}"
  if [[ -z "$arg" ]]; then
    printf 'Warning: MACHINE not provided. Allowed: lynnx, pete, oscer.\n' >&2
    return 1
  fi
  if ! _sm_valid "$arg"; then
    printf "Warning: invalid machine '%s'. Allowed: lynnx, pete, oscer.\n" "$arg" >&2
    return 1
  fi
  export MACHINE="$arg"
  sm_apply_modulepath "$MACHINE"
}

# CLI mode if executed directly
if ! __sm_is_sourced; then
  if set_modules "${1:-}"; then
    printf 'MACHINE=%s\n' "$MACHINE"
    exit 0
  else
    exit 1
  fi
fi

# print help if not already in .bashrc
if $(grep -q "/home/van/modulefiles/set_modules.sh" $HOME/.bashrc); then
echo '
add this to your ~/.bashrc
--------------------------

if [ -f "/home/van/modulefiles/set_modules.sh" ]; then
    . "/home/van/modulefiles/set_modules.sh"
    export MACHINE="oscer"
fi


# Re-apply on every shell start if MACHINE is already set in the environment.
# This keeps MODULEPATH correct for non-interactive shells.
if [ -n "${MACHINE:-}" ]; then
    set_modules "$MACHINE" >/dev/null || true
fi

'
fi
