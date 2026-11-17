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

QMHub selectors on Pete/OSU use `/scratch/van/shared_envs/qmhub2` and
`/scratch/van/shared_envs/qmhub2-mlpui`. HPCC provides only `qmhub2` under
`/home/van/Programs/miniforge3/envs`. Deactivate Conda before loading a selector;
the module changes executable and Python search paths reversibly, without
running activation hooks. Each installation retains its own host-built helPME
extension. HPCC's selector declares GNU7/OpenMPI3 FFTW 3.3.7 because its native
extension requires that library; a binary copied from another host is unsuitable.

Sander 26 modules preserve explicit thread settings. Missing thread counts use
`SLURM_CPUS_PER_TASK` when it is a positive integer, otherwise one thread.
On Pete, an explicit `QCTHREADS` also supplies missing OpenMP/MKL defaults.
MPI rank counts continue to control MPI processes rather than Q-Chem threads.
Pete's Sander module uses its existing Intel/MPI library paths without forcing
MKL libraries into every child with `LD_PRELOAD`; those preloads conflict with
the pinned PyTorch CUDA runtime used by `qmhub2-mlpui`.
HPCC's older Lmod also needs explicit restoration of originally empty variables;
its selectors preserve the distinction between empty and unset settings.
HPCC Q-Chem 6.1 remains available for standalone use but is excluded from the
QM/MM stack because that installed build lacks QMHub's required scalar ESP file.

Publishing module source does not deploy it to a running cluster. Before
updating an existing environment or its module, wait for jobs using that stack
to finish, retain package/native/module backups, and validate the installed
prefix with the site's existing Sander and Q-Chem installations. Do not change
environments or modulefiles underneath active production jobs.
