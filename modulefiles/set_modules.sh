#!/bin/bash
# shellcheck shell=bash
# Defines `set_modules` and optional CLI.
# Why: Safe to source in rc files without killing the shell.

__sm_is_sourced() { [[ "${BASH_SOURCE[0]}" != "$0" ]]; }

_sm_script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
PL888_MODULEFILES_ROOT="${PL888_MODULEFILES_ROOT:-$_sm_script_dir}"

_sm_valid() {
  case "${1:-}" in
    lynnx|pete|oscer|hpcc) return 0 ;;
    *) return 1 ;;
  esac
}

_sm_have_module() {
  # Works for both Tcl Modules and Lmod after their init script is sourced.
  type module &>/dev/null
}

_sm_find_machine_module_dirs() {
  # Prefer the canonical sites layout.
  local m="$1" d
  for d in "$PL888_MODULEFILES_ROOT/sites/$m/conda" "$PL888_MODULEFILES_ROOT/sites/$m/apps"; do
    [[ -d "$d" ]] && printf '%s\n' "$d"
  done
}

_sm_unuse_all_user_machine_dirs() {
  # Avoid path bloat when switching machines repeatedly.
  local m d
  for m in lynnx pete oscer hpcc; do
    for d in "$PL888_MODULEFILES_ROOT/sites/$m/conda" "$PL888_MODULEFILES_ROOT/sites/$m/apps"; do
      [[ -d "$d" ]] || continue
      module unuse "$d" >/dev/null 2>&1 || true
    done
  done
}

_sm_prune_lynnx_system_dirs() {
  # Keep local workstation module listings focused on PL888 modulefiles.
  local d
  module unload use.own >/dev/null 2>&1 || true
  for d in \
    "$HOME/privatemodules" \
    "/etc/environment-modules/modules" \
    "/usr/share/modules/versions" \
    "/usr/share/modules/\$MODULE_VERSION/modulefiles" \
    "/usr/share/modules/${MODULE_VERSION:-}/modulefiles" \
    "/usr/share/modules/modulefiles"; do
    [[ -n "$d" ]] || continue
    module unuse "$d" >/dev/null 2>&1 || true
  done
}

sm_apply_modulepath() {
  # Why: Keep MODULEPATH aligned with $MACHINE across interactive & non-interactive shells.
  local m="$1" path found=0
  _sm_have_module || return 0
  _sm_unuse_all_user_machine_dirs
  while IFS= read -r path; do
    [[ -n "$path" ]] || continue
    module use "$path"   # prepends path; idempotent if re-run
    found=1
  done < <(_sm_find_machine_module_dirs "$m")
  if [[ "$found" -eq 0 ]]; then
    printf "Warning: no modulefiles directory found for '%s' under %s/sites/%s\n" \
      "$m" "$PL888_MODULEFILES_ROOT" "$m" >&2
  fi
  if [[ "$m" == "lynnx" ]]; then
    _sm_prune_lynnx_system_dirs
  fi
}

set_modules() {
  local arg="${1:-${MACHINE:-}}"
  if [[ -z "$arg" ]]; then
    printf 'Warning: MACHINE not provided. Allowed: lynnx, pete, oscer, hpcc.\n' >&2
    return 1
  fi
  if ! _sm_valid "$arg"; then
    printf "Warning: invalid machine '%s'. Allowed: lynnx, pete, oscer, hpcc.\n" "$arg" >&2
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
