#!/bin/bash
# run-tests.sh — automated test runner for law-upstream
set -euo pipefail

PASS=0; FAIL=0
RED='\033[0;31m'; GREEN='\033[0;32m'; NC='\033[0m'
pass() { echo -e "${GREEN}PASS${NC} $1"; PASS=$((PASS + 1)); }
fail() { echo -e "${RED}FAIL${NC} $1 — $2"; FAIL=$((FAIL + 1)); }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"
GLOBAL_BIB="$HOME/.common-law/bib/refs.bib"
EXTRA_BIB="$HOME/.common-law/test-fixtures/sample-bib-entries.bib"
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

echo "=== law-upstream tests ==="
echo ""

# T8.1: upstream-bib.sh finds new entries
echo "--- T8.1: find new bib entries ---"
cp "$GLOBAL_BIB" "$TMPDIR/refs.bib"
# Append extra entries to the local bib
cp "$GLOBAL_BIB" "$TMPDIR/global-refs.bib"
cat "$EXTRA_BIB" >> "$TMPDIR/refs.bib"

# Create a minimal paper structure
mkdir -p "$TMPDIR/paper"
cp "$TMPDIR/refs.bib" "$TMPDIR/paper/refs.bib"

# Run upstream-bib.sh from the paper dir (it reads refs.bib from .)
OUT=$(bash "$SCRIPT_DIR/upstream-bib.sh" "$TMPDIR/paper" 2>&1) || true
echo "$OUT" | grep -q "extraref1" && pass "T8.1: extraref1 found" || fail "T8.1" "extraref1 not found"
echo "$OUT" | grep -q "extraref5" && pass "T8.1: extraref5 found" || fail "T8.1" "extraref5 not found"

# T8.2: No false positives when bibs are identical
echo "--- T8.2: identical bibs → no new entries ---"
mkdir -p "$TMPDIR/paper-identical"
cp "$GLOBAL_BIB" "$TMPDIR/paper-identical/refs.bib"
OUT2=$(bash "$SCRIPT_DIR/upstream-bib.sh" "$TMPDIR/paper-identical" 2>&1) || true
echo "$OUT2" | grep -q "No new bib entries" && pass "T8.2: no false positives" || fail "T8.2" "unexpected entries found"

# T8.3: upstream-claude.sh finds changes
echo "--- T8.3: CLAUDE.md changes ---"
mkdir -p "$TMPDIR/paper2"
cp "$HOME/.common-law/paper-style/CLAUDE.md" "$TMPDIR/paper2/CLAUDE.md"
# Insert a test change BEFORE the narrative section
sed -i '' '/^## Paper Narrative/i\
This is a test change added before the narrative section.
' "$TMPDIR/paper2/CLAUDE.md" 2>/dev/null || \
sed -i '/^## Paper Narrative/i\
This is a test change added before the narrative section.
' "$TMPDIR/paper2/CLAUDE.md"

OUT3=$(bash "$SCRIPT_DIR/upstream-claude.sh" "$TMPDIR/paper2" 2>&1) || true
echo "$OUT3" | grep -q "test change" && pass "T8.3: change detected" || fail "T8.3" "change not detected"

echo ""
echo "=== Results: ${GREEN}$PASS passed${NC}, ${RED}$FAIL failed${NC} ==="
exit $FAIL
