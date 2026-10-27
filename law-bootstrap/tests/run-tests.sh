#!/bin/bash
# run-tests.sh — automated test runner for law-bootstrap
# Run from the law-bootstrap skill directory.
# Usage: bash tests/run-tests.sh

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PASS=0
FAIL=0
TEMPDIR=$(mktemp -d)
SCRIPT="$(pwd)/scripts/new-paper.sh"

cleanup() {
    cd /tmp
    rm -rf "$TEMPDIR"
}
trap cleanup EXIT

pass() { echo -e "${GREEN}PASS${NC} $1"; PASS=$((PASS + 1)); }
fail() { echo -e "${RED}FAIL${NC} $1 — $2"; FAIL=$((FAIL + 1)); }

cd "$TEMPDIR"

echo "=== law-bootstrap tests ==="
echo ""

# T1.1: Creates correct directory structure
echo "--- T1.1: directory structure ---"
bash "$SCRIPT" --name t1 --venue nsdi --year 2027 --cycle spring > /dev/null 2>&1 || { fail "T1.1" "script failed"; }
for f in main.tex CLAUDE.md AGENTS.md refs.bib; do
    test -f "t1-nsdi-2027-spring/$f" || { fail "T1.1" "missing $f"; }
done
for d in .git sections figs reviews misc data templates; do
    test -d "t1-nsdi-2027-spring/$d" || { fail "T1.1" "missing dir $d"; }
done
test -f "t1-nsdi-2027-spring/templates/dev.plan.md" || fail "T1.1" "missing dev.plan.md"
test -f "t1-nsdi-2027-spring/templates/todo.md" || fail "T1.1" "missing todo.md"
pass "T1.1"
rm -rf t1-nsdi-2027-spring

# T1.2: Git repo
echo "--- T1.2: git repo ---"
bash "$SCRIPT" --name t2 --venue arxiv --year 2025 > /dev/null 2>&1 || { fail "T1.2" "script failed"; }
(cd t2-arxiv-2025 && git log --oneline | grep -q "Initial commit") || fail "T1.2" "no initial commit"
(cd t2-arxiv-2025 && git status --short | grep -qv "^[?M]") && fail "T1.2" "dirty git state" || true
pass "T1.2"
rm -rf t2-arxiv-2025

# T1.3: CLAUDE.md copied + narrative
echo "--- T1.3: CLAUDE.md ---"
bash "$SCRIPT" --name t3 --venue nsdi --year 2027 > /dev/null 2>&1 || { fail "T1.3" "script failed"; }
grep -q "Paper Narrative" t3-nsdi-2027/CLAUDE.md || fail "T1.3" "missing Paper Narrative"
N=$(grep -c "Paper Narrative" t3-nsdi-2027/CLAUDE.md)
test "$N" -eq 1 || fail "T1.3" "duplicate narrative sections ($N found, expected 1)"
pass "T1.3"
rm -rf t3-nsdi-2027

# T1.4: refs.bib identical
echo "--- T1.4: refs.bib ---"
bash "$SCRIPT" --name t4 --venue arxiv --year 2025 > /dev/null 2>&1 || { fail "T1.4" "script failed"; }
diff "$HOME/.common-law/bib/refs.bib" t4-arxiv-2025/refs.bib > /dev/null || fail "T1.4" "refs.bib differs from canonical"
pass "T1.4"
rm -rf t4-arxiv-2025

# T1.5: AGENTS.md fields
echo "--- T1.5: AGENTS.md ---"
bash "$SCRIPT" --name t5 --venue sigcomm --year 2026 > /dev/null 2>&1 || { fail "T1.5" "script failed"; }
grep -q "SIGCOMM 2026" t5-sigcomm-2026/AGENTS.md || fail "T1.5" "missing venue"
grep -q "FILL IN" t5-sigcomm-2026/AGENTS.md || fail "T1.5" "missing placeholder"
grep -q "pages" t5-sigcomm-2026/AGENTS.md || fail "T1.5" "missing page limit"
pass "T1.5"
rm -rf t5-sigcomm-2026

# T1.6: Correct document class per venue
echo "--- T1.6: venue document classes ---"
for v in nsdi sigcomm apnet arxiv; do
    bash "$SCRIPT" --name "t6-$v" --venue "$v" --year 2027 > /dev/null 2>&1 || { fail "T1.6" "script failed for $v"; }
    case "$v" in
        nsdi)   grep -q "usenix2019_v3" "t6-$v-${v}-2027/main.tex" || fail "T1.6" "$v main.tex missing usenix2019_v3" ;;
        sigcomm|apnet) grep -q "acmart" "t6-$v-${v}-2027/main.tex" || fail "T1.6" "$v main.tex missing acmart" ;;
        arxiv)  grep -q "PRIMEarxiv" "t6-$v-${v}-2027/main.tex" || fail "T1.6" "$v main.tex missing PRIMEarxiv" ;;
    esac
done
pass "T1.6"
rm -rf t6-*

# T1.7: Style files present
echo "--- T1.7: style files ---"
test -f "t6-nsdi-nsdi-2027/usenix2019_v3.sty" 2>/dev/null || { bash "$SCRIPT" --name t7-nsdi --venue nsdi --year 2027 > /dev/null 2>&1; }
test -f "t7-nsdi-nsdi-2027/usenix2019_v3.sty" 2>/dev/null || fail "T1.7" "missing usenix2019_v3.sty for nsdi"
bash "$SCRIPT" --name t7-sigcomm --venue sigcomm --year 2027 > /dev/null 2>&1
test -f t7-sigcomm-sigcomm-2027/acmart.cls || fail "T1.7" "missing acmart.cls for sigcomm"
bash "$SCRIPT" --name t7-arxiv --venue arxiv --year 2027 > /dev/null 2>&1
test -f t7-arxiv-arxiv-2027/PRIMEarxiv.sty || fail "T1.7" "missing PRIMEarxiv.sty for arxiv"
pass "T1.7"
rm -rf t7-*

# T1.8: Missing parameter → error
echo "--- T1.8: missing args ---"
bash "$SCRIPT" --name t8 --venue nsdi > /dev/null 2>&1 && fail "T1.8" "should have failed on missing --year" || pass "T1.8"

# T1.9: Existing directory → warn
echo "--- T1.9: existing dir ---"
mkdir -p t9-nsdi-2027
OUT=$(bash "$SCRIPT" --name t9 --venue nsdi --year 2027 2>&1) || true
if echo "$OUT" | grep -q "WARNING"; then
    pass "T1.9"
else
    fail "T1.9" "no warning for existing dir (got: $OUT)"
fi
rm -rf t9-nsdi-2027

# T1.10: macOS platform
echo "--- T1.10: macOS ---"
uname -s | grep -q "Darwin" && pass "T1.10 (macOS)" || pass "T1.10 (non-macOS — skip)"

echo ""
echo "=== Results: ${GREEN}$PASS passed${NC}, ${RED}$FAIL failed${NC} ==="
exit $FAIL
