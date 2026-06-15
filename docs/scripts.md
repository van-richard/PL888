# Scripts

`Scripts/bin/` is the reduced command facade for Python-oriented command links.
Add it to `PATH` explicitly when those commands are needed:

```bash
export PATH="$HOME/github/PL888/Scripts/bin:$PATH"
```

Shell helpers and site-specific interactive launchers are loaded as Bash
aliases instead.

- `Scripts/python/`: Python command implementations and utility modules.
- `Scripts/slurm/`: standalone SLURM examples, including `jupyter.slurm`.
- `Scripts/apptainer/`: Apptainer examples, including Pete-specific examples
  under `Scripts/apptainer/sites/pete/`.
- `Scripts/chimeraX/` and `Scripts/tcl/`: application-specific scripts.
- `Scripts/mbar/`: MBAR research modules retained pending consolidation.
- `Scripts/styles/`: style files such as Matplotlib styles.

The old shell-command wrappers, Pete SLURM launchers, and short compatibility
commands were removed from `Scripts/bin/`. Use `docs/aliases.md` for common
shell helpers such as `vchange_shell`, `vchange_perms`, and OSU/Pete helpers
such as `batch`.

## Legacy Research Utilities

Some research utilities remain intentionally unchanged:

- `Scripts/python/gen_cvs.py` and `nframes.py` use site-specific Python
  shebangs and require scientific packages not installed by CI.
- `Scripts/python/sqm_param2.py` imports personal external parameter modules.
- `Scripts/mbar/mbar_pmf_original.py` and `mbar_pmf_panxl.py` remain separate
  pending a domain-specific review.

TODO: make these utilities configurable before treating them as portable
commands.
