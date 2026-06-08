# Bash Aliases

Interactive Bash shells load aliases through
`Profiles/bash/alias_loader.bash`. The loader derives the repository location
from its own path, so the checkout can be moved without updating hardcoded
paths.

Canonical repository aliases live only in the `aliases/common/`, `aliases/os/`,
`aliases/scheduler/`, `aliases/hpc/`, and `aliases/host/` subdirectories. Top-level
`aliases/*.aliases.bash` compatibility files are not loaded by the alias
loader.

Aliases are loaded in this order:

1. `aliases/common/*.bash`, sorted by filename
2. `aliases/os/linux.bash` on Linux or `aliases/os/macos.bash` on macOS
3. `aliases/hpc/${PL888_SITE}.bash` when `PL888_SITE` is set
4. `aliases/scheduler/pbs.bash` on Linux systems where `qsub` is available
5. `aliases/scheduler/slurm.bash` on Linux systems where `sbatch` or `squeue` is available
6. `aliases/host/${short_hostname}.bash` when that file exists
7. `~/.config/pl888/aliases.bash` for private local aliases

Optional files and directories may be absent. The loader does not create or
modify shell startup files.

## Controls

Select site-specific aliases before sourcing `env.sh`:

```bash
export PL888_SITE="pete"
source "$HOME/github/PL888/env.sh"
```

Valid site values are `pete`, `oscer`, `lynnx`, `local`, `polaris`, and
`crux`.

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

## vrsync

`vrsync` is a common alias helper, so it is available on every host and site.
It copies a remote directory into the current system using SSH-backed `rsync`.
Remote hosts may be SSH config aliases.

```bash
vrsync cluster:project/run
vrsync cluster project/run
vrsync cluster /absolute/remote/path ./local-copy
vrsync cluster
```

The last form preserves the former interactive behavior and prompts for the
remote path. Relative remote paths are resolved under `VRSYNC_REMOTE_ROOT`,
which defaults to `.` on the remote host. The local path defaults to the
remote directory's basename.

Configuration variables:

- `VRSYNC_REMOTE_ROOT`: base for relative remote paths
- `VRSYNC_HOSTS`: space-separated host aliases offered by Bash completion
- `VRSYNC_TEMP_DIR`: rsync temporary directory; defaults to `/tmp`
- `VRSYNC_RSYNC_OPTS`: additional space-separated rsync options
- `VRSYNC_FILTER_PRESET`: `amber-qmmm` by default, or `none`

Completion also reads concrete `Host` aliases from `~/.ssh/config` and regular
files directly under `~/.ssh/config.d/`. Wildcard and negated entries are
ignored.

To retain the former Pete defaults, put this in
`~/.config/pl888/aliases.bash` or an appropriate private/site alias file:

```bash
export VRSYNC_REMOTE_ROOT="/scratch/van"
export VRSYNC_HOSTS="osu ou dtn2"
```

The former `Setup/aliases.sh` compatibility wrapper has been removed. The
legacy setup script still mentions that old path for historical reference, but
the supported mechanism is `Profiles/bash/alias_loader.bash`.

## PBS aliases

PBS helpers are loaded automatically only on Linux systems where `qsub` is in
`PATH`. They are skipped on macOS, on Linux systems without PBS, and on hosts
that do not expose `qsub`.

The PBS helper file defines:

- `vsub`: wrapper around `qsub` that defaults the job name to the current
  directory basename unless the user already supplied `-N` or `--job-name`
- `pbfree`: wrapper around `pbsnodes -avSj`
- `vdel`: delete jobs by PBS job name using `qselect -N` and `qdel`

Polaris and Crux share these PBS helpers through `aliases/scheduler/pbs.bash`.
Use `aliases/hpc/polaris.bash` or `aliases/hpc/crux.bash` only for future
site-specific additions. Polaris is a mixed CPU/GPU cluster, Crux is mainly
CPU, and both primarily rely on Cray compiler environments.

## SLURM aliases

SLURM helpers are loaded automatically only on Linux systems where `sbatch` or
`squeue` is in `PATH`. They are skipped on macOS and on Linux systems without
SLURM.

The SLURM helper file defines:

- `sq`: formatted `squeue` wrapper
- `me`: show jobs for the current user or a supplied username
- `vbatch`: wrapper around `sbatch` that defaults the job name to the current
  directory basename unless the user already supplied `-J` or `--job-name`

The former Pete-specific SLURM aliases have been generalized into
`aliases/scheduler/slurm.bash`.
