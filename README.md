# PL888s (n.) /plāt-s/

Personal templates for shell configuration, CLI tools, research scripts, and
workstation setup.

> [!WARNING]
> Review scripts before running them. Some scripts under `Setup/` install
> software, use `sudo`, access the network, or modify files in `$HOME`.

## Getting Started

Clone the repository to `$HOME/github/PL888`:

```bash
mkdir -p "$HOME/github"
git clone https://github.com/van-richard/PL888.git "$HOME/github/PL888"
```

### Safe environment setup

Review `env.sh`, then source it for the current interactive shell:

```bash
source "$HOME/github/PL888/env.sh"
```

To load it in future Bash sessions, add that source command once:

```bash
grep -qxF 'source "$HOME/github/PL888/env.sh"' "$HOME/.bashrc" ||
    printf '%s\n' 'source "$HOME/github/PL888/env.sh"' >> "$HOME/.bashrc"
```

Then start a new shell or run:

```bash
source "$HOME/.bashrc"
```

This path loads the existing environment and aliases without running the
software installers in `Setup/`. The environment loader expects `~/.vbashrc`
and adds this repository's `Scripts/bin` command facade to `PATH`.

### Advanced setup

The top-level `setup.sh` provides a dry-run-first path for linking selected
configuration files:

```bash
./setup.sh
./setup.sh --apply
./setup.sh --apply --backup
```

Existing destinations are skipped unless `--backup` is supplied. Personal
profiles and HPC modulefiles require explicit flags; run `./setup.sh --help`
for the complete option list.

The scripts in `Setup/` remain independent, optional examples. Inspect and
adapt an individual script before running it. Depending on the script, it may:

- modify `~/.bashrc` or other dotfiles;
- install software with a package manager or `sudo`;
- download and execute network content;
- assume Linux, macOS, or machine-specific paths.

Do not run the entire directory as an automated installer.

## Example Configuration Files

Example configurations for Bash, Vim, tmux, VMD, ChimeraX, and related tools
are grouped by application under `Profiles/`. Treat them as templates rather
than files that are safe to overwrite into `$HOME`.

Additional layout and machine-specific notes are available under `docs/`.
Alias selection and local override behavior are documented in
[`docs/aliases.md`](docs/aliases.md).

## Validation

GitHub Actions performs lightweight, non-mutating hygiene checks:

- `bash -n` for shell scripts;
- ShellCheck error checks when ShellCheck is available;
- `py_compile` for Python scripts, with bytecode written outside the checkout.

The workflow does not execute setup scripts or install GUI or scientific
software.
