# Modules

Site-specific definitions are grouped under `sites/`. The `lynnx`, `oscer`,
`pete`, and `hpcc` paths at this directory's top level are compatibility symlinks.
Exact-copy Conda environment definitions are centralized under `templates/`;
their module names remain available through symlinks in each site tree.

Source `set_modules.sh` directly and select a site explicitly:

```bash
source "$HOME/modulefiles/set_modules.sh"
set_modules pete
```

Valid site names are `lynnx`, `pete`, `oscer`, and `hpcc`. Set `MACHINE` before
sourcing if the selection should be inherited by child shells:

```bash
export MACHINE="pete"
source "$HOME/modulefiles/set_modules.sh"
set_modules "$MACHINE"
```

`modules.sh` remains as a compatibility wrapper. It uses `MACHINE` when set,
otherwise it recognizes only matching site hostnames.
