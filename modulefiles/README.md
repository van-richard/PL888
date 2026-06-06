# Modules

Site-specific definitions are grouped under `sites/`. The `lynnx`, `oscer`,
and `pete` paths at this directory's top level are compatibility symlinks.
Exact-copy Conda environment definitions are centralized under `templates/`;
their module names remain available through symlinks in each site tree.

Add the module loader to Bash:

```bash
echo 'source $HOME/modulefiles/modules.sh' >> ~/.bashrc
```
