# Profiles

`Profiles/` contains dotfile templates grouped by application:

- `bash/`: Bash startup and alias templates.
- `vim/`: Vim configuration and optional plugin configuration.
- `tmux/`: the current tmux configuration and historical variants.
- `conda/`: a personal Conda configuration example.
- `vmd/`: VMD configurations, including display-specific variants.

The top-level setup script links selected canonical profiles. Existing files
are skipped unless `--backup` is supplied.

Files under `variants/` are retained for reference and are not installed by
default. Display-specific VMD profiles and `condarc.example` are personal or
machine-specific templates.

Former flat paths such as `Profiles/vimrc.9.0` remain as relative symlinks
during the migration.
