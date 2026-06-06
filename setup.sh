#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DRY_RUN=1
BACKUP=0
PORTABLE=1
PERSONAL_PROFILES=0
HPC_MODULES=0
BACKUP_STAMP="$(date +%Y%m%d-%H%M%S)"

usage() {
    cat <<'EOF'
Usage: ./setup.sh [options]

Preview or create symlinks for PL888 configuration files. The default is a
dry run of the portable profile.

Options:
  --dry-run            Print operations without changing files (default).
  --apply              Perform the printed operations.
  --backup             Move conflicting destinations to timestamped backups.
  --no-portable        Do not configure the portable Bash, Vim, and tmux files.
  --personal-profiles  Include personal profiles such as the Conda example.
  --hpc-modules        Include the machine-specific modulefiles directory.
  -h, --help           Show this help.

Existing files are never replaced unless --backup is supplied. Network and
privileged installers under Setup/ are intentionally not run by this script.
EOF
}

print_command() {
    printf '%s' "$1"
    shift
    printf ' %q' "$@"
    printf '\n'
}

run_file_operation() {
    print_command "$@"
    if (( ! DRY_RUN )); then
        "$@"
    fi
}

backup_path() {
    local destination="$1"
    local candidate="${destination}.backup-${BACKUP_STAMP}"
    local suffix=0

    while [[ -e "$candidate" || -L "$candidate" ]]; do
        suffix=$((suffix + 1))
        candidate="${destination}.backup-${BACKUP_STAMP}-${suffix}"
    done

    printf '%s\n' "$candidate"
}

ensure_parent_directory() {
    local destination="$1"
    local parent
    parent="$(dirname "$destination")"

    if [[ ! -d "$parent" ]]; then
        run_file_operation mkdir -p "$parent"
    fi
}

link_file() {
    local source="$1"
    local destination="$2"
    local existing_target
    local backup

    if [[ ! -e "$source" ]]; then
        printf 'ERROR missing source: %s\n' "$source" >&2
        return 1
    fi

    if [[ -L "$destination" ]]; then
        existing_target="$(readlink "$destination")"
        if [[ "$existing_target" == "$source" ]]; then
            printf 'UNCHANGED %s -> %s\n' "$destination" "$source"
            return 0
        fi
    fi

    if [[ -e "$destination" || -L "$destination" ]]; then
        if (( ! BACKUP )); then
            printf 'SKIP existing destination (use --backup): %s\n' "$destination"
            return 0
        fi

        backup="$(backup_path "$destination")"
        run_file_operation mv "$destination" "$backup"
    fi

    ensure_parent_directory "$destination"
    run_file_operation ln -s "$source" "$destination"
}

while (( $# > 0 )); do
    case "$1" in
        --dry-run)
            DRY_RUN=1
            ;;
        --apply)
            DRY_RUN=0
            ;;
        --backup)
            BACKUP=1
            ;;
        --no-portable)
            PORTABLE=0
            ;;
        --personal-profiles)
            PERSONAL_PROFILES=1
            ;;
        --hpc-modules)
            HPC_MODULES=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            printf 'ERROR unknown option: %s\n\n' "$1" >&2
            usage >&2
            exit 2
            ;;
    esac
    shift
done

if (( DRY_RUN )); then
    printf 'Mode: dry-run\n'
else
    printf 'Mode: apply\n'
fi
printf 'Repository: %s\n' "$REPO_ROOT"

if (( PORTABLE )); then
    link_file "$REPO_ROOT/Profiles/bash/bashrc" "$HOME/.vbashrc"
    link_file "$REPO_ROOT/Profiles/vim/vimrc" "$HOME/.vimrc"
    link_file "$REPO_ROOT/Profiles/tmux/tmux.conf" "$HOME/.tmux.conf"
fi

if (( PERSONAL_PROFILES )); then
    printf 'Including explicitly requested personal profiles.\n'
    link_file "$REPO_ROOT/Profiles/conda/condarc.example" "$HOME/.condarc"
fi

if (( HPC_MODULES )); then
    printf 'Including explicitly requested machine-specific HPC modulefiles.\n'
    link_file "$REPO_ROOT/modulefiles" "$HOME/modulefiles"
fi

printf 'Setup complete.\n'
