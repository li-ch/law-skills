#!/bin/bash
# upstream-claude.sh — find CLAUDE.md changes (excluding narrative section)
# Usage: bash upstream-claude.sh [paper_dir]

set -euo pipefail

PAPER_DIR="${1:-.}"
GLOBAL_CLAUDE="$HOME/.common-law/paper-style/CLAUDE.md"
LOCAL_CLAUDE="$PAPER_DIR/CLAUDE.md"

if [ ! -f "$LOCAL_CLAUDE" ]; then
    echo "No CLAUDE.md found in $PAPER_DIR"
    exit 0
fi

if [ ! -f "$GLOBAL_CLAUDE" ]; then
    echo "Global CLAUDE.md not found at $GLOBAL_CLAUDE"
    exit 1
fi

# Strip the narrative section from both (everything from "## Paper Narrative" onwards)
strip_narrative() {
    sed '/^## Paper Narrative/,$d' "$1"
}

LOCAL_STRIPPED=$(strip_narrative "$LOCAL_CLAUDE")
GLOBAL_STRIPPED=$(strip_narrative "$GLOBAL_CLAUDE")

# Diff
DIFF_OUT=$(diff <(echo "$GLOBAL_STRIPPED") <(echo "$LOCAL_STRIPPED") 2>/dev/null || true)

if [ -z "$DIFF_OUT" ]; then
    echo "No CLAUDE.md changes to upstream (excluding narrative section)."
    exit 0
fi

echo "CLAUDE.md changes (narrative section excluded):"
echo "$DIFF_OUT" | head -40

echo ""
echo "To upstream, the law-upstream skill will merge these changes into:"
echo "  $GLOBAL_CLAUDE"
