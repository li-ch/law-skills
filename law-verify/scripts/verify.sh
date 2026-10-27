#!/bin/bash
# verify.sh — post-build checks for LaTeX papers
# Usage: bash verify.sh [paper_root_dir]

PAPER_DIR="${1:-.}"
TEX_FILES=$(find "$PAPER_DIR" -maxdepth 2 -name "*.tex" -not -path "*/temp/*" 2>/dev/null)
LOG_FILE="$PAPER_DIR/temp/main.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

check_pass() { echo -e "  ${GREEN}[PASS]${NC} $1"; PASS=$((PASS + 1)); }
check_fail() { echo -e "  ${RED}[FAIL]${NC} $1"; FAIL=$((FAIL + 1)); }
check_warn() { echo -e "  ${YELLOW}[WARN]${NC} $1"; WARN=$((WARN + 1)); }

echo "=== law-verify ==="
echo ""

# Check 1: No long dashes (em dash --- or en dash --)
echo "--- Check 1: No long dashes (--- or --) ---"
DASH_ISSUES=0
for f in $TEX_FILES; do
    while IFS=: read -r line_num rest; do
        [ -z "$line_num" ] && continue
        DASH_ISSUES=$((DASH_ISSUES + 1))
        check_fail "$f:$line_num — long dash found"
    done < <(grep -nE '(---|(?<![a-zA-Z0-9])--(?![a-zA-Z0-9]))' "$f" 2>/dev/null | grep -vE '\\\\|\\cite|\\ref|\\cref|%.*--|^[0-9]+:\s*#' || true)
done
if [ "$DASH_ISSUES" -eq 0 ]; then
    check_pass "No long dashes found"
fi

# Check 2: All \ref{} resolve
echo "--- Check 2: Undefined references ---"
if [ -f "$LOG_FILE" ]; then
    UNDEF_REF=$(grep -c "LaTeX Warning: Reference.*undefined" "$LOG_FILE" 2>/dev/null || echo 0)
    UNDEF_REF=$(echo "$UNDEF_REF" | tr -d '[:space:]')
    if [ "$UNDEF_REF" -gt 0 ] 2>/dev/null; then
        check_fail "$UNDEF_REF undefined reference(s)"
    else
        check_pass "All references resolve"
    fi
else
    check_warn "No log file at $LOG_FILE"
fi

# Check 3: No undefined citations
echo "--- Check 3: Undefined citations ---"
if [ -f "$LOG_FILE" ]; then
    UNDEF_CITE=$(grep -c "LaTeX Warning: Citation.*undefined" "$LOG_FILE" 2>/dev/null || echo 0)
    UNDEF_CITE=$(echo "$UNDEF_CITE" | tr -d '[:space:]')
    if [ "$UNDEF_CITE" -gt 0 ] 2>/dev/null; then
        check_fail "$UNDEF_CITE undefined citation(s)"
    else
        check_pass "All citations resolve"
    fi
else
    check_warn "No log file at $LOG_FILE"
fi

# Check 4: No \textbf{} mid-paragraph
# Approach: find lines with \textbf{ that are NOT \noindent\textbf headings
# Then check if the bold content is a number (OK) or text (FAIL)
echo "--- Check 4: \\textbf{} mid-paragraph ---"
BOLD_ISSUES=0
for f in $TEX_FILES; do
    grep -n '\\textbf{' "$f" 2>/dev/null | while IFS=: read -r lnum line; do
        [ -z "$lnum" ] && continue
        # Skip \noindent\textbf headings
        echo "$line" | grep -qE '^\s*\\noindent\s*\\textbf\{' && continue
        
        # Extract all \textbf{...} content using grep
        echo "$line" | grep -o '\\textbf{[^}]*}' 2>/dev/null | while read -r bold; do
            [ -z "$bold" ] && continue
            inner=$(echo "$bold" | sed 's/\\textbf{//;s/}//')
            
            # Allow numbers, percentages, math, priority labels,
            # table header text, and enumerate item labels
            case "$inner" in
                [0-9]*)       ;;  # starts with digit → OK
                \$*)          ;;  # math → OK
                P[0-9])       ;;  # P5 → OK
                [A-Z][0-9]*)  ;;  # A1, B2 → OK (enumerate labels)
                [A-Z][a-z]*)  ;;  # Name, Throughput → OK (table headers)
                *)
                    echo "FAIL:$f:$lnum: $inner"
                    ;;
            esac
        done
    done
done > /tmp/verify-bold-$$.txt 2>/dev/null
BOLD_ISSUES=$(wc -l < /tmp/verify-bold-$$.txt 2>/dev/null || echo 0)
BOLD_ISSUES=$(echo "$BOLD_ISSUES" | tr -d '[:space:]')
if [ "$BOLD_ISSUES" -gt 0 ] 2>/dev/null; then
    while IFS= read -r fline; do
        [ -z "$fline" ] && continue
        fname=$(echo "$fline" | cut -d: -f2)
        lnum=$(echo "$fline" | cut -d: -f3)
        inner=$(echo "$fline" | cut -d: -f4-)
        check_fail "$fname:$lnum — mid-paragraph \\textbf{$inner}"
    done < /tmp/verify-bold-$$.txt
    rm -f /tmp/verify-bold-$$.txt
else
    check_pass "No mid-paragraph \\textbf{} found (numbers, table headers, labels OK)"
    rm -f /tmp/verify-bold-$$.txt
fi

# Check 5: No single hyphens used as dashes (space-hyphen-space or start-hyphen-space)
# Compound-word hyphens (e.g., "pattern-correlated", "cost-effective") are allowed.
echo "--- Check 5: Hyphens used as dashes in prose ---"
HYPHEN_ISSUES=0
for f in $TEX_FILES; do
    while IFS=: read -r line_num rest; do
        [ -z "$line_num" ] && continue
        HYPHEN_ISSUES=$((HYPHEN_ISSUES + 1))
        check_fail "$f:$line_num — hyphen used as dash (space - space or similar)"
    done < <(grep -nE '(^|[[:space:]])-([[:space:]]|$)|[[:space:]]-[[:space:]]' "$f" 2>/dev/null | grep -vE '\\\\|\\cite|\\ref|\\cref|%.*-|^[0-9]+:\s*#' | head -10 || true)
done
if [ "$HYPHEN_ISSUES" -eq 0 ]; then
    check_pass "No hyphens used as dashes (compound-word hyphens OK)"
fi

# Check 6: Appendix cross-references (warning only)
echo "--- Check 6: Appendix breadcrumbs ---"
APPENDIX_ISSUES=0
# Check if any section files contain appendix labels and find all section labels
MAIN_BODY_TEX=$(find "$PAPER_DIR/sections" -name "*.tex" 2>/dev/null || true)
for f in $MAIN_BODY_TEX; do
    # Collect all \cref{} and \ref{} references
    REFS=$(grep -oP '\\cref\{[^}]*\}|\\ref\{[^}]*\}' "$f" 2>/dev/null | sed 's/\\cref{//' | sed 's/\\ref{//' | sed 's/}//' | sort -u)
done

# Find appendix labels
APP_TEX=$(find "$PAPER_DIR/sections" -maxdepth 1 -name "*appendix*" -o -name "*app*" 2>/dev/null || true)
for f in $APP_TEX; do
    APP_LABELS=$(grep -oP '\\label\{[^}]*\}' "$f" 2>/dev/null | sed 's/\\label{//' | sed 's/}//')
    for label in $APP_LABELS; do
        CREF_COUNT=$(grep -l "{$label}" "$PAPER_DIR"/sections/[!a]*.tex 2>/dev/null | wc -l | tr -d ' ')
        if [ "$CREF_COUNT" -eq 0 ]; then
            APPENDIX_ISSUES=$((APPENDIX_ISSUES + 1))
            check_warn "Appendix label '$label' may lack main-body \\cref. Ensure there is a breadcrumb sentence."
        fi
    done
done
if [ "$APPENDIX_ISSUES" -eq 0 ]; then
    check_pass "All appendix labels have main-body cross-references"
fi

# Check 7: No "X, not Y" contrastive apposition (writing rule 23)
echo "--- Check 7: X-not-Y contrastive apposition ---"
NOTY_ISSUES=0
for f in $TEX_FILES; do
    while IFS=: read -r line_num rest; do
        [ -z "$line_num" ] && continue
        NOTY_ISSUES=$((NOTY_ISSUES + 1))
        check_fail "$f:$line_num — 'X, not Y' contrastive apposition (rule 23: state the positive claim; give the contrast its own sentence)"
    done < <(grep -nE ', not |[a-z] rather than |not because|, never [a-z]' "$f" 2>/dev/null | grep -vE '^[0-9]+:\s*%|\\%' | head -5 || true)
done
if [ "$NOTY_ISSUES" -eq 0 ]; then
    check_pass "No X-not-Y contrastive appositions"
fi

echo ""
echo "=== Results: ${GREEN}$PASS passed${NC}, ${YELLOW}$WARN warnings${NC}, ${RED}$FAIL failed${NC} ==="
exit $FAIL
