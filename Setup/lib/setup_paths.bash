#!/usr/bin/env bash

# Shared path handling for manual Setup/tools installers.

pl888_setup_common_options() {
    cat <<'EOF'
Common options:
  --repo-root DIR     PL888 checkout path. Defaults to PL888_REPO_ROOT or this repo.
  --local-dir DIR     User-local install path. Defaults to PL888_LOCAL_DIR or ~/.local.
  --scripts-dir DIR   Scripts/bin path. Defaults to PL888_SCRIPTS_DIR or repo Scripts/bin.
  --home-dir DIR      Home directory for startup files. Defaults to PL888_HOME_DIR or $HOME.
  -h, --help          Show help.
EOF
}

pl888_setup_resolve_paths() {
    local helper_dir
    local detected_repo_root

    helper_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
    detected_repo_root="$(cd -- "${helper_dir}/../.." && pwd -P)"

    PL888_REPO_ROOT="${PL888_REPO_ROOT:-$detected_repo_root}"
    PL888_LOCAL_DIR="${PL888_LOCAL_DIR:-${HOME}/.local}"
    PL888_SCRIPTS_DIR="${PL888_SCRIPTS_DIR:-${PL888_REPO_ROOT}/Scripts/bin}"
    PL888_HOME_DIR="${PL888_HOME_DIR:-${HOME}}"
    PL888_SETUP_HELP=0

    while (($# > 0)); do
        case "$1" in
            --repo-root)
                [[ $# -gt 1 ]] || {
                    printf 'ERROR: --repo-root requires a directory\n' >&2
                    return 2
                }
                PL888_REPO_ROOT="$2"
                shift 2
                ;;
            --repo-root=*)
                PL888_REPO_ROOT="${1#*=}"
                shift
                ;;
            --local-dir)
                [[ $# -gt 1 ]] || {
                    printf 'ERROR: --local-dir requires a directory\n' >&2
                    return 2
                }
                PL888_LOCAL_DIR="$2"
                shift 2
                ;;
            --local-dir=*)
                PL888_LOCAL_DIR="${1#*=}"
                shift
                ;;
            --scripts-dir)
                [[ $# -gt 1 ]] || {
                    printf 'ERROR: --scripts-dir requires a directory\n' >&2
                    return 2
                }
                PL888_SCRIPTS_DIR="$2"
                shift 2
                ;;
            --scripts-dir=*)
                PL888_SCRIPTS_DIR="${1#*=}"
                shift
                ;;
            --home-dir)
                [[ $# -gt 1 ]] || {
                    printf 'ERROR: --home-dir requires a directory\n' >&2
                    return 2
                }
                PL888_HOME_DIR="$2"
                shift 2
                ;;
            --home-dir=*)
                PL888_HOME_DIR="${1#*=}"
                shift
                ;;
            -h|--help)
                PL888_SETUP_HELP=1
                shift
                ;;
            *)
                printf 'ERROR: unknown option: %s\n' "$1" >&2
                return 2
                ;;
        esac
    done

    export PL888_REPO_ROOT PL888_LOCAL_DIR PL888_SCRIPTS_DIR PL888_HOME_DIR
    export PL888_SETUP_HELP
}
