#!/bin/bash
# Securely adjust permissions in a directory tree:
#
#  - Directories: 750 (user rwx, group rx, others none)
#  - Files:       640 (user rw, group r, others none)
#
# Usage:
#   ./chmod.sh            # apply to current directory
#   ./chmod.sh /path/dir  # apply to specific directory


#find . -type d | while read i; do
#    chmod g+rx $i
#done


set -euo pipefail

TARGET="${1:-.}"

# Expand and check
if [[ ! -d "$TARGET" ]]; then
    echo "Error: $TARGET is not a directory"
    exit 1
fi

MODE_DIR=750   # rwxr-x---
MODE_FILE=640  # rw-r-----

echo "Securing directory tree under: $TARGET"
echo "  Directories → $MODE_DIR"
echo "  Files      → $MODE_FILE"

# Fix directories
find "$TARGET" -type d -print0 | while IFS= read -r -d '' dir; do
    chmod "$MODE_DIR" "$dir"
done

# Fix files
find "$TARGET" -type f -print0 | while IFS= read -r -d '' file; do
    chmod "$MODE_FILE" "$file"
done

echo "Done."

