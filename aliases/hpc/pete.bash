#!/usr/bin/env bash

# Compatibility wrapper. OSU/Pete aliases live in aliases/hpc/osu.bash.

_pl888_pete_alias_dir="$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P
)"

# shellcheck source=osu.bash disable=SC1091
. "${_pl888_pete_alias_dir}/osu.bash"

unset _pl888_pete_alias_dir
