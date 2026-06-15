# HPC And Machine-Specific Files

The following content is machine- or site-specific and is not portable by
default:

- `Scripts/apptainer/sites/pete/`
- `modulefiles/sites/lynnx/`
- `modulefiles/sites/oscer/`
- `modulefiles/sites/pete/`
- `modulefiles/sites/hpcc/`
- monitor-specific files under `Profiles/vmd/variants/`
- `Profiles/conda/condarc.example`
- scripts containing `/home`, `/scratch`, `/archive`, cluster hostnames, or
  site module names

Treat these files as examples. Review usernames, paths, partitions, software
versions, and scheduler directives before use. The top-level `setup.sh`
requires explicit flags before linking personal profiles or HPC modulefiles.

OSU/Pete interactive SLURM helpers now live in `aliases/hpc/osu.bash`; the
`aliases/hpc/pete.bash` file remains as a compatibility wrapper. Both are
loaded through the Bash alias loader. The remaining `Scripts/slurm/` content is
for standalone examples such as `jupyter.slurm`.

Compatibility links currently preserve `modulefiles/{lynnx,oscer,pete,hpcc}`;
new modulefile references should use the corresponding `modulefiles/sites/`
paths.
