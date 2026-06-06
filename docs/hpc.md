# HPC And Machine-Specific Files

The following content is machine- or site-specific and is not portable by
default:

- `Scripts/slurm/sites/pete/`
- `Scripts/apptainer/sites/pete/`
- `modulefiles/sites/lynnx/`
- `modulefiles/sites/oscer/`
- `modulefiles/sites/pete/`
- monitor-specific files under `Profiles/vmd/variants/`
- `Profiles/conda/condarc.example`
- scripts containing `/home`, `/scratch`, `/archive`, cluster hostnames, or
  site module names

Treat these files as examples. Review usernames, paths, partitions, software
versions, and scheduler directives before use. The top-level `setup.sh`
requires explicit flags before linking personal profiles or HPC modulefiles.

Compatibility links currently preserve `modulefiles/{lynnx,oscer,pete}` and
`Scripts/slurm/pete`; new references should use the corresponding `sites/`
paths.
