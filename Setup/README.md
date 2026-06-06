# Manual Installers

The scripts in this directory are task-specific installers. They are not
called by the repository's top-level `setup.sh`.

Review a script before running it. Depending on the script, it may:

- use `sudo`, `apt`, or Homebrew;
- download files or execute remote installer scripts;
- modify files under `$HOME`;
- assume a particular operating system, username, or workstation layout.

Package-manager scripts are grouped under `packages/`, individual tool
installers under `tools/`, and superseded environment setup scripts under
`legacy/`. Compatibility symlinks preserve the former top-level paths.

Use the top-level setup entry point for dotfile links:

```bash
./setup.sh
./setup.sh --apply
./setup.sh --apply --backup
```

The first command is a dry run. Existing destinations are skipped unless
`--backup` is supplied. Personal profiles and HPC modulefiles require the
explicit `--personal-profiles` and `--hpc-modules` flags.

The portable profile links `Profiles/bash/bashrc` as `~/.vbashrc`, leaving an
existing `~/.bashrc` in place. The environment loader can then be sourced from
`~/.bashrc` as documented in the top-level README.

`Setup/aliases.sh` is a deprecated compatibility wrapper. Alias loading is
handled by `Profiles/bash/alias_loader.bash`, and the wrapper does not create
or modify files under `$HOME`.
