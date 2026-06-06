# AGENTS.md

## Repository purpose

PL888 is a personal dotfiles, CLI configuration, and research-workstation setup repo.
Prioritize safe, reviewable changes over aggressive automation.

## Safety rules

- Do not run setup scripts that modify $HOME unless explicitly asked.
- Do not overwrite existing dotfiles without backup logic.
- Do not introduce network installs into setup scripts without documenting them.
- Treat machine-specific paths, usernames, cluster names, and HPC settings as examples unless clearly portable.
- Prefer dry-run modes for installer/linker scripts.

## Cleanup goals

- Improve README clarity.
- Make setup behavior idempotent.
- Separate portable defaults from personal/local overrides.
- Add validation for shell scripts and Python scripts.
- Add CI that checks formatting/linting without mutating user environments.

## Validation

When editing shell scripts, run:
- `bash -n <script>`
- `shellcheck <script>` when available

When editing Python scripts, run:
- `python -m py_compile <script>`
- `ruff check .` if ruff config is added

Do not reformat unrelated legacy files unless the task is specifically a formatting-only cleanup.
