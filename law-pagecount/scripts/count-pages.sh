#!/bin/bash
# count-pages.sh — count pages per section from a compiled PDF
# Usage: bash count-pages.sh [paper_root_dir]
# Requires: pdftk or Python with pikepdf

set -euo pipefail

PAPER_DIR="${1:-.}"
PDF=$(find "$PAPER_DIR" -maxdepth 2 -name "main-*.pdf" -not -path "*/temp/*" 2>/dev/null | sort | tail -1)

if [ -z "$PDF" ]; then
    PDF="$PAPER_DIR/temp/main.pdf"
    if [ ! -f "$PDF" ]; then
        echo "ERROR: No PDF found. Build the paper first."
        exit 1
    fi
fi

echo "--- Page count for: $PDF ---"
echo ""

# Try Python with pikepdf first
if python3 -c "import pikepdf" 2>/dev/null; then
    python3 - "$PDF" << 'PYEOF'
import sys, pikepdf
from collections import OrderedDict

pdf = pikepdf.open(sys.argv[1])
if '/Outlines' in pdf.Root:
    outlines = []
    def walk(items, depth=0):
        for item in items:
            if hasattr(item, 'title') and hasattr(item, 'dest'):
                title = str(item.title)
                page_num = pdf.pages.index(pdf.get_object(item.dest)) + 1
                outlines.append((title, page_num, depth))
            if hasattr(item, 'children'):
                walk(item.children, depth + 1)
    walk(pdf.Root.Outlines)

    # Compute page ranges
    for i, (title, start, depth) in enumerate(outlines):
        end = outlines[i+1][1] - 1 if i + 1 < len(outlines) else len(pdf.pages)
        pages = end - start + 1
        indent = "  " * depth
        print(f"{indent}{title} — pages {start}–{end} ({pages} pg)")
else:
    print("WARNING: pikepdf not available. Install with: pip install pikepdf")
    print("Falling back to pdftk...")
    if command -v pdftk &>/dev/null; then
        data=$(pdftk "$PDF" dump_data 2>/dev/null | grep -E "^(BookmarkTitle|BookmarkPageNumber)" || true)
        # Simple output: just show bookmarks with page numbers
        prev_title=""
        prev_page=""
        while IFS= read -r line; do
            if [[ "$line" =~ BookmarkTitle:\ (.*) ]]; then
                prev_title="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ BookmarkPageNumber:\ (.*) ]]; then
                echo "  $prev_title — page ${BASH_REMATCH[1]}"
            fi
        done <<< "$data"
    else
        echo "ERROR: Neither pikepdf nor pdftk is available."
        echo "Install pikepdf: pip install pikepdf"
        exit 1
    fi
fi

echo ""
