# Setup

Use the top-level `setup.sh` for dotfile links. It defaults to a dry run and
does not invoke the installers under `Setup/`.

```bash
./setup.sh
./setup.sh --apply
./setup.sh --apply --backup
```

`Setup/packages/` contains operating-system package installers.
`Setup/tools/` contains installers for individual user tools.
`Setup/legacy/` contains superseded shell-environment setup scripts.

Active `Setup/tools/` scripts derive paths from the checkout and do not require
the historical `_vgithub`, `_vlocal`, `_vsetup`, `_vtemplates`, or `_vscripts`
variables. Use `PL888_REPO_ROOT`, `PL888_LOCAL_DIR`, `PL888_SCRIPTS_DIR`, and
`PL888_HOME_DIR`, or pass matching flags such as `--local-dir` and
`--repo-root` to a tool script.

These installers are manual and may use the network, package managers,
`sudo`, or paths under `$HOME`. Review them before running them.
