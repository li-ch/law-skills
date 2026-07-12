#!/bin/bash
# resubmit.sh — prepare a paper for resubmission to a new venue
# Usage: bash resubmit.sh --venue <venue> --year <year> [--cycle <cycle>]

set -euo pipefail

VENUE=""
YEAR=""
CYCLE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --venue) VENUE="$2"; shift 2 ;;
        --year)  YEAR="$2"; shift 2 ;;
        --cycle) CYCLE="$2"; shift 2 ;;
        *) echo "Unknown argument: $1"; exit 1 ;;
    esac
done

if [[ -z "$VENUE" || -z "$YEAR" ]]; then
    echo "ERROR: --venue and --year are required."
    exit 1
fi

# Current directory is the paper repo
CURRENT_DIR=$(pwd)
PAPER_NAME=$(basename "$CURRENT_DIR")
# Extract just the paper name (before the first -venue-year)
BASE_NAME=$(echo "$PAPER_NAME" | sed -E 's/-[a-z]+-[0-9]+.*$//')

if [[ -n "$CYCLE" ]]; then
    NEW_DIR="${BASE_NAME}-${VENUE}-${YEAR}-${CYCLE}"
else
    NEW_DIR="${BASE_NAME}-${VENUE}-${YEAR}"
fi

NEW_PATH="$(dirname "$CURRENT_DIR")/$NEW_DIR"

if [[ -d "$NEW_PATH" ]]; then
    echo "ERROR: Target directory '$NEW_PATH' already exists."
    exit 1
fi

echo "Resubmitting '$PAPER_NAME' → '$NEW_DIR'"
echo ""

# Copy the repo
echo "Copying repository..."
cp -r "$CURRENT_DIR" "$NEW_PATH"

cd "$NEW_PATH"

# Create archive directory and move old PDFs and reviews
echo "Archiving old artifacts..."
mkdir -p archive
for f in main-*.pdf; do
    [ -f "$f" ] && mv "$f" archive/
done
if [ -d reviews ] && [ "$(ls -A reviews 2>/dev/null)" ]; then
    cp -r reviews/* archive/ 2>/dev/null || true
    rm -rf reviews/*
fi

# Map venue to display name
VENUE_DISPLAY="$VENUE"
case "$VENUE" in
    nsdi) VENUE_DISPLAY="NSDI" ;;
    sigcomm) VENUE_DISPLAY="SIGCOMM" ;;
    apnet) VENUE_DISPLAY="APNet" ;;
    arxiv) VENUE_DISPLAY="arXiv" ;;
esac

# Update AGENTS.md with new venue
echo "Updating AGENTS.md..."
if [ -f AGENTS.md ]; then
    # Update the venue line
    if grep -q "Venue:" AGENTS.md 2>/dev/null; then
        sed -i '' "s/Venue:.*/Venue: $VENUE_DISPLAY $YEAR/" AGENTS.md 2>/dev/null || \
        sed -i "s/Venue:.*/Venue: $VENUE_DISPLAY $YEAR/" AGENTS.md
    fi
fi

# Copy new venue template files
echo "Swapping venue templates..."
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# Find law-bootstrap's venue templates
BOOTSTRAP_DIR="$SKILL_DIR/law-bootstrap"
if [ -d "$BOOTSTRAP_DIR/assets/venue-templates/$VENUE" ]; then
    # Remove old venue files (keep sections, figs, data)
    rm -f ./*.cls ./*.sty ./*.bst 2>/dev/null || true
    cp "$BOOTSTRAP_DIR/assets/venue-templates/$VENUE/"* . 2>/dev/null || true
    echo "  Copied venue template files for $VENUE"
else
    echo "  WARNING: No template files found for venue '$VENUE'"
    echo "  You need law-bootstrap installed to access venue templates."
    echo "  Copy the venue .cls/.sty/.bst files manually into this directory."
fi

# Git commit
echo "Committing..."
git add -A 2>/dev/null || true
git commit -m "resubmit: switch venue to $VENUE_DISPLAY $YEAR" 2>/dev/null || true

echo ""
echo "Resubmission complete: $NEW_PATH"
echo ""
echo "Next steps:"
echo "  1. Review the new main.tex for venue-specific formatting"
echo "  2. Update AGENTS.md with new page limit"
echo "  3. Run 'bash build.sh' to verify the new template compiles"
