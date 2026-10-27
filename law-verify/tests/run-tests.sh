#!/bin/bash
# run-tests.sh — automated test runner for law-verify
set -euo pipefail

PASS=0; FAIL=0
RED='\033[0;31m'; GREEN='\033[0;32m'; NC='\033[0m'
pass() { echo -e "${GREEN}PASS${NC} $1"; PASS=$((PASS + 1)); }
fail() { echo -e "${RED}FAIL${NC} $1 — $2"; FAIL=$((FAIL + 1)); }

SCRIPT="$(pwd)/scripts/verify.sh"
SAMPLE="$HOME/.common-law/test-fixtures/sample-paper"
BAD="$HOME/.common-law/test-fixtures/bad-paper"

echo "=== law-verify tests ==="
echo ""

# T5.1: Clean paper → all pass
echo "--- T5.1: clean paper ---"
OUT=$(bash "$SCRIPT" "$SAMPLE" 2>&1)
echo "$OUT" | grep -q "0 failed" && pass "T5.1: clean paper passes" || fail "T5.1" "clean paper should pass"

# T5.2: Emdashes detected
echo "--- T5.2: emdash detection ---"
OUT=$(bash "$SCRIPT" "$BAD" 2>&1)
echo "$OUT" | grep -q "emdash" && pass "T5.2: emdashes detected" || fail "T5.2" "emdashes not detected"

# T5.5: Mid-paragraph bold detected
echo "--- T5.5: bold detection ---"
echo "$OUT" | grep -q "mid-paragraph" && pass "T5.5: mid-paragraph bold detected" || fail "T5.5" "bold not detected"

# T5.6: Hyphens detected
echo "--- T5.6: hyphen detection ---"
echo "$OUT" | grep -q "hyphen" && pass "T5.6: hyphens detected" || fail "T5.6" "hyphens not detected"

echo ""
echo "=== Results: ${GREEN}$PASS passed${NC}, ${RED}$FAIL failed${NC} ==="
exit $FAIL
