#!/usr/bin/env bash

_pl888_pete_alias_dir="$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")/pete.d" && pwd -P
)"

while IFS= read -r _pl888_pete_alias_file; do
    # shellcheck source=/dev/null
    . "$_pl888_pete_alias_file"
done < <(
    find "$_pl888_pete_alias_dir" -maxdepth 1 -type f -name '*.bash' -print |
        LC_ALL=C sort
)

unset _pl888_pete_alias_file _pl888_pete_alias_dir
