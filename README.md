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
software installers in `Setup/`. The current environment loader expects
`~/.vbashrc` and retains the existing `$HOME/Scripts/bin` convention, so review
those assumptions before enabling it on a new machine.

### Advanced setup

The scripts in `Setup/` are independent, optional examples; there is no single
`Setup.sh` entry point. Inspect and adapt an individual script before running
it. Depending on the script, it may:

- modify `~/.bashrc` or other dotfiles;
- install software with a package manager or `sudo`;
- download and execute network content;
- assume Linux, macOS, or machine-specific paths.

Do not run the entire directory as an automated installer.

## Example Configuration Files

Example configurations for Bash, Vim, tmux, VMD, ChimeraX, and related tools
are stored in `Profiles/`. Treat them as templates rather than files that are
safe to overwrite into `$HOME`.


