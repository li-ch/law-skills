#!/bin/bash
# run-tests.sh — automated test runner for law-build
set -euo pipefail

PASS=0; FAIL=0
RED='\033[0;31m'; GREEN='\033[0;32m'; NC='\033[0m'
pass() { echo -e "${GREEN}PASS${NC} $1"; PASS=$((PASS + 1)); }
fail() { echo -e "${RED}FAIL${NC} $1 — $2"; FAIL=$((FAIL + 1)); }

SCRIPT="$(pwd)/scripts/build.sh"
SAMPLE="$HOME/.common-law/test-fixtures/sample-paper"
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

echo "=== law-build tests ==="
echo ""

# T3.1: Build produces PDF
echo "--- T3.1: build produces PDF ---"
cp -r "$SAMPLE" "$TMPDIR/test"
cp "$SAMPLE/../law-skills/law-bootstrap/assets/venue-templates/nsdi/usenix2019_v3.sty" "$TMPDIR/test/" 2>/dev/null || cp /Users/Admin/paper/paper_src/law-skills/law-bootstrap/assets/venue-templates/nsdi/usenix2019_v3.sty "$TMPDIR/test/"
cd "$TMPDIR/test"
bash "$SCRIPT" > /dev/null 2>&1
test -f "temp/main.pdf" && pass "T3.1: PDF produced" || fail "T3.1" "no temp/main.pdf"
ts_pdfs=$(ls main-*.pdf 2>/dev/null | wc -l | tr -d ' ')
test "$ts_pdfs" -gt 0 && pass "T3.1: timestamped PDF" || fail "T3.1" "no timestamped PDF"
cd - > /dev/null

# T3.2: Check pass count in output
echo "--- T3.2: 4-pass with bibtex ---"
cd "$TMPDIR/test"
OUT=$(bash "$SCRIPT" 2>&1)
echo "$OUT" | grep -q "\[1/4\]" && pass "T3.2: 4-pass detected" || fail "T3.2" "no 4-pass"
cd - > /dev/null

# T3.6: Invalid LaTeX
echo "--- T3.6: invalid LaTeX ---"
mkdir -p "$TMPDIR/broken"
echo "NOT VALID LATEX" > "$TMPDIR/broken/main.tex"
cd "$TMPDIR/broken"
bash "$SCRIPT" > /dev/null 2>&1 && fail "T3.6" "should have failed" || pass "T3.6: failed on bad LaTeX"
cd - > /dev/null

# T3.7: Missing pdflatex detection
echo "--- T3.7: pdflatex detection ---"
which pdflatex > /dev/null 2>&1 && pass "T3.7: pdflatex found" || fail "T3.7" "pdflatex not found"

echo ""
echo "=== Results: ${GREEN}$PASS passed${NC}, ${RED}$FAIL failed${NC} ==="
exit $FAIL
