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
3. `aliases/hpc/${PL888_SITE}.bash` when `PL888_SITE` is set, or a supported
   site is detected from the host
4. `aliases/scheduler/pbs.bash` on Linux systems where `qsub` is available
5. `aliases/scheduler/slurm.bash` on Linux systems where `sbatch` or `squeue` is available
6. `aliases/host/${short_hostname}.bash` when that file exists
7. `~/.config/pl888/aliases.bash` for private local aliases

Optional files and directories may be absent. The loader does not create or
modify shell startup files.

## Controls

Select site-specific aliases before sourcing `Profiles/bash/bashrc` or the
alias loader:

```bash
export PL888_SITE="osu"
source "$HOME/github/PL888/Profiles/bash/alias_loader.bash"
```

Valid site values are `osu`, `ou`, `polaris`, `crux`, `hpcc`, `lynnx`, and
`local`. Compatibility values `pete` and `oscer` are accepted and map to `osu`
and `ou`.

When `PL888_SITE` is unset, the loader automatically selects site aliases from
the login node hostname or FQDN:

- `osu`: `pete*` or `*.hpc.okstate.edu`
- `ou`: `schooner*`, `dtn2*`, or `*.oscer.ou.edu`
- `polaris`: `polaris*` or `polaris.alcf.anl.gov`
- `crux`: `crux*` or `crux.alcf.anl.gov`
- `hpcc`: `hpcc*` or `hpcc.brandeis.edu`

Explicit `PL888_SITE` values always take precedence.

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

## Common helpers

Common helper functions are loaded from `aliases/common/` on every interactive
Bash shell:

- `vchange_shell`: show valid login shells from `/etc/shells`, prompt for a
  new shell, and run `chsh -s`
- `vchange_perms [directory]`: set directories to `750` and files to `640`
  under the target directory, defaulting to the current directory

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
- `vacctmgr_allowed`: show the current user's SLURM account associations with
  `sacctmgr show user $USER withassoc`
- `vbatch`: wrapper around `sbatch` that defaults the job name to the current
  directory basename unless the user already supplied `-J` or `--job-name`

OSU/Pete and HPCC use the shared SLURM helpers from
`aliases/scheduler/slurm.bash`. Use `aliases/hpc/osu.bash` or
`aliases/hpc/hpcc.bash` for site-specific
partition helpers and other cluster-local additions.

OSU/Pete defines:

- `batch`: start an interactive shell on the `batch` partition with 32 tasks,
  20 GB memory, and a 12 hour limit
- `bigmem`: start an interactive shell on the `bigmem` partition with 16
  tasks, 8 GB memory, and a 12 hour limit
- `bullet`: start an interactive GPU shell on the `bullet` partition with 16
  tasks, 8 GB memory, and a 12 hour limit
- `express`: start an interactive shell on the `express` partition with 16
  tasks, 8 GB memory, and a 1 hour limit

HPCC defines:

- `guest-compute`: start an interactive login shell on the `guest-compute`
  partition with 16 tasks, 32 GB memory, and an 8 hour limit
