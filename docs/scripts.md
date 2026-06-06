# Scripts

`Scripts/bin/` is the command facade placed on `PATH`. Entries there should be
relative symlinks to one canonical implementation.

- `Scripts/shell/`: shell command implementations.
- `Scripts/python/`: Python command implementations and utility modules.
- `Scripts/slurm/common/`: reusable SLURM helpers.
- `Scripts/slurm/sites/`: cluster-specific launchers and environment snippets.
- `Scripts/apptainer/sites/pete/`: site-specific Apptainer examples.
- `Scripts/chimeraX/` and `Scripts/tcl/`: application-specific scripts.
- `Scripts/mbar/`: MBAR research modules retained pending consolidation.

Commands exposed from cluster-specific directories should include the site
name in their preferred command name. Older short names may remain as
compatibility symlinks during migration.

Current compatibility examples include `pete-batch` as the preferred command
and `batch` as its older short alias. The former `Scripts/bash/` path is also a
symlink to `Scripts/shell/`.

## Legacy Research Utilities

Some research utilities remain intentionally unchanged:

- `Scripts/python/gen_cvs.py` and `nframes.py` use site-specific Python
  shebangs and require scientific packages not installed by CI.
- `Scripts/python/sqm_param2.py` imports personal external parameter modules.
- `Scripts/mbar/mbar_pmf.py` and `mbar_pmf2.py` remain separate pending a
  domain-specific review.

TODO: make these utilities configurable before treating them as portable
commands.
