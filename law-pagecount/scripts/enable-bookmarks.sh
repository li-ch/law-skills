#!/bin/bash
# enable-bookmarks.sh — ensure PDF bookmarks are enabled in the paper
# Usage: bash enable-bookmarks.sh [paper_root_dir]

set -euo pipefail

PAPER_DIR="${1:-.}"
MAIN_TEX="$PAPER_DIR/main.tex"

if [ ! -f "$MAIN_TEX" ]; then
    echo "ERROR: $MAIN_TEX not found"
    exit 1
fi

# Check if bookmarks are already enabled
if grep -q 'bookmarks=true' "$MAIN_TEX" 2>/dev/null; then
    echo "Bookmarks already enabled."
    exit 0
fi

# Check if hyperref is loaded
if ! grep -q '\\usepackage.*{hyperref}' "$MAIN_TEX"; then
    echo "WARNING: hyperref package not found in main.tex. Adding it."
    # Add \hypersetup before \begin{document}
    sed -i.bak '/\\begin{document}/i\
\\hypersetup{bookmarks=true,bookmarksdepth=3}\
' "$MAIN_TEX"
else
    # Add bookmarks=true to existing hypersetup, or add new one
    if grep -q '\\hypersetup{' "$MAIN_TEX"; then
        # Add bookmarks=true to existing hypersetup
        sed -i.bak 's/\\hypersetup{/\\hypersetup{bookmarks=true,/g' "$MAIN_TEX"
    else
        # Add new hypersetup before \begin{document}
        sed -i.bak '/\\begin{document}/i\
\\hypersetup{bookmarks=true,bookmarksdepth=3}\
' "$MAIN_TEX"
    fi
fi

echo "Bookmarks enabled in $MAIN_TEX"
echo "NOTE: Remember to re-disable bookmarks before submission."
