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

# Check 1: No emdashes
echo "--- Check 1: No emdashes (---) ---"
EMDASH_ISSUES=0
for f in $TEX_FILES; do
    while IFS= read -r line_num; do
        [ -z "$line_num" ] && continue
        EMDASH_ISSUES=$((EMDASH_ISSUES + 1))
        check_fail "$f:$line_num — emdash found"
    done < <(grep -n -- '---' "$f" 2>/dev/null || true)
done
if [ "$EMDASH_ISSUES" -eq 0 ]; then
    check_pass "No emdashes found"
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
            
            # Allow numbers, percentages, math, priority labels
            case "$inner" in
                [0-9]*) ;;  # starts with digit → OK
                \$*)    ;;  # math → OK
                P[0-9]) ;;  # P5 → OK
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
    check_pass "No mid-paragraph \\textbf{} found (bold numbers OK)"
    rm -f /tmp/verify-bold-$$.txt
fi

# Check 5: No hyphens in prose (skip LaTeX commands, comments, and known compound indicators)
echo "--- Check 5: Hyphens in prose ---"
HYPHEN_ISSUES=0
for f in $TEX_FILES; do
    while IFS=: read -r line_num rest; do
        [ -z "$line_num" ] && continue
        HYPHEN_ISSUES=$((HYPHEN_ISSUES + 1))
        check_fail "$f:$line_num — hyphen in prose"
    done < <(grep -nE '[a-z]-[a-z]' "$f" 2>/dev/null | grep -vE '\\\\|\\cite|\\ref|\\cref|%.*-|^[0-9]+:\s*#' | head -10)
done
if [ "$HYPHEN_ISSUES" -eq 0 ]; then
    check_pass "No hyphens in prose"
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

echo ""
echo "=== Results: ${GREEN}$PASS passed${NC}, ${YELLOW}$WARN warnings${NC}, ${RED}$FAIL failed${NC} ==="
exit $FAIL
