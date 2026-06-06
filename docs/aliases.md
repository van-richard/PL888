# Bash Aliases

Interactive Bash shells load aliases through
`Profiles/bash/alias_loader.bash`. The loader derives the repository location
from its own path, so the checkout can be moved without updating hardcoded
paths.

Canonical repository aliases live only in the `aliases/common/`, `aliases/os/`,
`aliases/hpc/`, and `aliases/host/` subdirectories. Top-level
`aliases/*.aliases.bash` compatibility files are not loaded by the alias
loader.

Aliases are loaded in this order:

1. `aliases/common/*.bash`, sorted by filename
2. `aliases/os/linux.bash` on Linux or `aliases/os/macos.bash` on macOS
3. `aliases/hpc/${PL888_SITE}.bash` when `PL888_SITE` is set
4. `aliases/host/${short_hostname}.bash` when that file exists
5. `~/.config/pl888/aliases.bash` for private local aliases

Optional files and directories may be absent. The loader does not create or
modify shell startup files.

## Controls

Select site-specific aliases before sourcing `env.sh`:

```bash
export PL888_SITE="pete"
source "$HOME/github/PL888/env.sh"
```

Valid site values are `pete`, `oscer`, `lynnx`, and `local`.

Disable repository aliases:

```bash
export PL888_NO_ALIASES=1
```

Print each loaded alias file:

```bash
export PL888_DEBUG=1
```

Private aliases belong in:

```text
~/.config/pl888/aliases.bash
```

The former `Setup/aliases.sh` compatibility wrapper has been removed. The
legacy setup script still mentions that old path for historical reference, but
the supported mechanism is `Profiles/bash/alias_loader.bash`.
