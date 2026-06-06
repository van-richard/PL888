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

These installers are manual and may use the network, package managers,
`sudo`, or paths under `$HOME`. Review them before running them.

