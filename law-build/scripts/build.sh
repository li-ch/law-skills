#!/bin/bash
# build.sh — compile a LaTeX paper with pdflatex
# Usage: bash build.sh [main.tex]  (defaults to main.tex in current directory)

set -euo pipefail

MAIN="${1:-main}"
BASENAME="${MAIN%.tex}"
TEMPDIR="temp"
FLAGS="-output-directory=$TEMPDIR -interaction=nonstopmode"

mkdir -p "$TEMPDIR"

# pdflatex exits 0 even when there are LaTeX errors,
# so we must check the log for errors after every pass.
check_log() {
    local logfile="$TEMPDIR/$BASENAME.log"
    if [ -f "$logfile" ]; then
        if grep -qE '^!|^.*Error:' "$logfile" 2>/dev/null; then
            echo "BUILD FAILED: LaTeX errors found in $logfile"
            grep -nE '^!|^.*Error:' "$logfile" | head -20
            return 1
        fi
    fi
    return 0
}

# Detect bibtex requirement
NEEDS_BIBTEX=false
if grep -q '\\bibliography{' "${BASENAME}.tex" 2>/dev/null; then
    NEEDS_BIBTEX=true
fi

if $NEEDS_BIBTEX; then
    # 4-pass: pdflatex → bibtex → pdflatex → pdflatex
    echo "[1/4] First pdflatex pass..."
    pdflatex $FLAGS "${BASENAME}.tex" || { echo "BUILD FAILED: pdflatex pass 1"; exit 1; }
    check_log || exit 1

    echo "[2/4] BibTeX pass..."
    export BIBINPUTS=.:${BIBINPUTS:-}
    bibtex "$TEMPDIR/$BASENAME" 2>/dev/null || true

    echo "[3/4] Second pdflatex pass..."
    pdflatex $FLAGS "${BASENAME}.tex" || { echo "BUILD FAILED: pdflatex pass 3"; exit 1; }
    check_log || exit 1

    echo "[4/4] Third pdflatex pass (resolving references)..."
    pdflatex $FLAGS "${BASENAME}.tex" || { echo "BUILD FAILED: pdflatex pass 4"; exit 1; }
    check_log || exit 1
else
    # 3-pass: pdflatex → pdflatex → pdflatex (cross-refs need 3)
    echo "[1/3] First pdflatex pass..."
    pdflatex $FLAGS "${BASENAME}.tex" || { echo "BUILD FAILED: pdflatex pass 1"; exit 1; }
    check_log || exit 1

    echo "[2/3] Second pdflatex pass..."
    pdflatex $FLAGS "${BASENAME}.tex" || { echo "BUILD FAILED: pdflatex pass 2"; exit 1; }
    check_log || exit 1

    echo "[3/3] Third pdflatex pass (resolving references)..."
    pdflatex $FLAGS "${BASENAME}.tex" || { echo "BUILD FAILED: pdflatex pass 3"; exit 1; }
    check_log || exit 1
fi

if [ ! -f "$TEMPDIR/$BASENAME.pdf" ]; then
    echo "BUILD FAILED: No PDF produced. Check $TEMPDIR/$BASENAME.log"
    exit 1
fi

# Timestamped copy
STAMP=$(date +%Y%m%d%H%M)
OUTPDF="${BASENAME}-${STAMP}.pdf"
cp "$TEMPDIR/$BASENAME.pdf" "$OUTPDF"

echo "Done: $OUTPDF"
