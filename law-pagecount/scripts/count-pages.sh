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

pdf = pikepdf.open(sys.argv[1])

def deref(o):
    return pdf.get_object(o.objgen) if getattr(o, "is_indirect", False) else o

# Build name -> page map from the /Names/Dests tree (hyperref named destinations)
named = {}
stack = []
root = pdf.Root
if "/Names" in root and "/Dests" in root.Names:
    stack.append(root.Names.Dests)
elif "/Dests" in root:
    d = deref(root.Dests)
    for k in d.keys():
        try:
            dest = deref(d[k])
            if isinstance(dest, pikepdf.Dictionary) and "/D" in dest:
                dest = dest["/D"]
            page = deref(dest[0])
            named[str(k)] = next(
                (n + 1 for n, p in enumerate(pdf.pages) if p.objgen == page.objgen), None)
        except Exception:
            pass
while stack:
    node = deref(stack.pop())
    if "/Kids" in node:
        stack.extend(node.Kids)
    if "/Names" in node:
        arr = node.Names
        for i in range(0, len(arr) - 1, 2):
            try:
                dest = deref(arr[i + 1])
                if isinstance(dest, pikepdf.Dictionary) and "/D" in dest:
                    dest = dest["/D"]
                page = deref(dest[0])
                named[str(arr[i])] = next(
                    (n + 1 for n, p in enumerate(pdf.pages) if p.objgen == page.objgen), None)
            except Exception:
                pass

def to_page(d):
    # d: a destination (array, name, string, or {/D: ...} dict) -> 1-based page or None
    try:
        d = deref(d)
        if isinstance(d, (pikepdf.String,)) or d.__class__.__name__ == "Name":
            return named.get(str(d))
        if isinstance(d, pikepdf.Dictionary):
            if "/D" not in d:
                return None
            d = d["/D"]
            d = deref(d)
            if isinstance(d, pikepdf.String) or d.__class__.__name__ == "Name":
                return named.get(str(d))
        page = deref(d[0])
        return next((n + 1 for n, p in enumerate(pdf.pages) if p.objgen == page.objgen), None)
    except Exception:
        return None

def page_of(item):
    pg = None
    try:
        if item.destination is not None:
            pg = to_page(item.destination)
    except Exception:
        pg = None
    if pg is None:
        try:
            raw = item.obj
            if "/Dest" in raw:
                pg = to_page(raw["/Dest"])
            elif "/A" in raw and "/D" in raw["/A"]:
                pg = to_page(raw["/A"]["/D"])
        except Exception:
            pg = None
    return pg

entries = []
try:
    with pdf.open_outline() as outline:
        def walk(items, depth=0):
            for it in items:
                pg = page_of(it)
                if pg is not None and str(it.title).strip():
                    entries.append((str(it.title), pg, depth))
                walk(it.children, depth + 1)
        walk(outline.root)
except Exception as e:
    print(f"WARNING: could not read outline: {e}")

for i, (title, start, depth) in enumerate(entries):
    end = entries[i + 1][1] - 1 if i + 1 < len(entries) else len(pdf.pages)
    if end < start:
        end = start
    pages = end - start + 1
    indent = "  " * depth
    print(f"{indent}{title} — pages {start}-{end} ({pages} pg)")

if not entries:
    print("WARNING: no outline/bookmarks found in PDF.")
    print("Run scripts/enable-bookmarks.sh and rebuild, then count again.")
PYEOF
else
    echo "WARNING: pikepdf not available. Install with: pip install pikepdf"
    echo "Falling back to pdftk..."
    if command -v pdftk &>/dev/null; then
        data=$(pdftk "$PDF" dump_data 2>/dev/null | grep -E "^(BookmarkTitle|BookmarkPageNumber)" || true)
        prev_title=""
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
