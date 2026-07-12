#!/bin/bash
# upstream-bib.sh — find new bib entries in paper repo not in global bib
# Usage: bash upstream-bib.sh [paper_dir]

set -euo pipefail

PAPER_DIR="${1:-.}"
GLOBAL_BIB="$HOME/.common-law/bib/refs.bib"
LOCAL_BIB="$PAPER_DIR/refs.bib"

if [ ! -f "$LOCAL_BIB" ]; then
    echo "No refs.bib found in $PAPER_DIR"
    exit 0
fi

if [ ! -f "$GLOBAL_BIB" ]; then
    echo "Global bib not found at $GLOBAL_BIB"
    exit 1
fi

# Extract citation keys from both files
extract_keys() {
    grep '^@' "$1" | sed 's/^@[a-z]*{//' | sed 's/,$//' | sort -u
}

GLOBAL_KEYS=$(extract_keys "$GLOBAL_BIB")
LOCAL_KEYS=$(extract_keys "$LOCAL_BIB")

# Find keys in local that aren't in global
NEW_KEYS=$(comm -23 <(echo "$LOCAL_KEYS") <(echo "$GLOBAL_KEYS"))

if [ -z "$NEW_KEYS" ]; then
    echo "No new bib entries to upstream."
    exit 0
fi

# Print new entries
echo "New bib entries found:"
for key in $NEW_KEYS; do
    # Find the full entry in the local bib
    ENTRY=$(awk "/^@.*{$key,/,/^}/" "$LOCAL_BIB")
    echo ""
    echo "--- $key ---"
    echo "$ENTRY" | head -8
done

echo ""
echo "To upstream selected entries, the law-upstream skill will append them to:"
echo "  $GLOBAL_BIB"
