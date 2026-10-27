#!/bin/bash
# run-tests.sh — automated test runner for law-resubmit
set -euo pipefail

PASS=0; FAIL=0
RED='\033[0;31m'; GREEN='\033[0;32m'; NC='\033[0m'
pass() { echo -e "${GREEN}PASS${NC} $1"; PASS=$((PASS + 1)); }
fail() { echo -e "${RED}FAIL${NC} $1 — $2"; FAIL=$((FAIL + 1)); }

SCRIPT="$(pwd)/scripts/resubmit.sh"
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

echo "=== law-resubmit tests ==="
echo ""

# Create a mock paper repo with a .git dir
MOCK="$TMPDIR/testpaper-nsdi-2027"
mkdir -p "$MOCK/sections" "$MOCK/reviews" "$MOCK/archive"
echo "test" > "$MOCK/main.tex"
echo "Venue: NSDI 2027" > "$MOCK/AGENTS.md"
touch "$MOCK/reviews/r1.txt"
echo "old pdf" > "$MOCK/main-202601010000.pdf"
cd "$MOCK" && git init > /dev/null 2>&1 && git add -A > /dev/null 2>&1 && git commit -m "init" > /dev/null 2>&1

# T9.1: Creates new directory with correct name
echo "--- T9.1: new directory name ---"
cd "$MOCK"
bash "$SCRIPT" --venue sigcomm --year 2028 > /dev/null 2>&1 || true
test -d "$TMPDIR/testpaper-sigcomm-2028" && pass "T9.1: directory created" || fail "T9.1" "directory not created"

# T9.2: Copies old content
echo "--- T9.2: content preserved ---"
test -f "$TMPDIR/testpaper-sigcomm-2028/main.tex" && pass "T9.2: main.tex preserved" || fail "T9.2" "main.tex missing"
test -d "$TMPDIR/testpaper-sigcomm-2028/sections" && pass "T9.2: sections preserved" || fail "T9.2" "sections missing"

# T9.3: Archives old PDFs
echo "--- T9.3: PDFs archived ---"
test -f "$TMPDIR/testpaper-sigcomm-2028/archive/main-202601010000.pdf" && pass "T9.3: PDF archived" || fail "T9.3" "PDF not archived"
test ! -f "$TMPDIR/testpaper-sigcomm-2028/main-202601010000.pdf" && pass "T9.3: PDF removed from root" || fail "T9.3" "PDF still in root"

# T9.4: Archives reviews
echo "--- T9.4: reviews archived ---"
test -f "$TMPDIR/testpaper-sigcomm-2028/archive/r1.txt" && pass "T9.4: review archived" || fail "T9.4" "review note archived"

# T9.5: AGENTS.md updated
echo "--- T9.5: AGENTS.md updated ---"
grep -q "SIGCOMM 2028" "$TMPDIR/testpaper-sigcomm-2028/AGENTS.md" 2>/dev/null && pass "T9.5: AGENTS.md updated" || fail "T9.5" "AGENTS.md not updated"

# T9.6: Git history preserved
echo "--- T9.6: git history ---"
cd "$TMPDIR/testpaper-sigcomm-2028"
COMMITS=$(git log --oneline 2>/dev/null | wc -l | tr -d ' ')
test "$COMMITS" -ge 2 && pass "T9.6: git history preserved ($COMMITS commits)" || fail "T9.6" "git history broken"

# T9.7: Original repo untouched
echo "--- T9.7: original untouched ---"
test -d "$MOCK" && pass "T9.7: original repo preserved" || fail "T9.7" "original repo deleted"

echo ""
echo "=== Results: ${GREEN}$PASS passed${NC}, ${RED}$FAIL failed${NC} ==="
exit $FAIL
