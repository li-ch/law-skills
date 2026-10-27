#!/usr/bin/env python3
"""capture_comments.py — verbatim capture of review comments in a tex paper.

Scans <paper-root>/main.tex and <paper-root>/sections/*.tex for inline
review comments: any '%' not escaped as '\\%' whose trailing text is
non-empty. Skips the file's own scaffold dividers (lines whose comment
starts with '%%') and the common stub marker '% TODO: law-write to
fill' when it is the only content of a stub line.

Usage:
  python3 capture_comments.py [paper-root]       # numbered verbatim list
  python3 capture_comments.py [paper-root] --check  # exit 1 if any found
"""
from __future__ import annotations

import sys
from pathlib import Path
import re

COMMENT = re.compile(r"(?<!\\)%")
STUB = re.compile(r"^\s*%\s*TODO: law-write to fill\s*$")


def capture(root: Path) -> list[tuple[str, int, str]]:
    files = []
    main = root / "main.tex"
    if main.exists():
        files.append(main)
    sec = root / "sections"
    if sec.is_dir():
        files.extend(sorted(sec.glob("*.tex")))
    out = []
    for f in files:
        for lineno, line in enumerate(f.read_text(encoding="utf-8")
                                      .splitlines(), start=1):
            m = COMMENT.search(line)
            if not m:
                continue
            text = line[m.end():]
            if text.startswith("%"):        # '%%' scaffold divider
                continue
            if not text.strip():
                continue
            if STUB.match(line):
                continue
            out.append((str(f.relative_to(root)), lineno, text.rstrip()))
    return out


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    check = "--check" in sys.argv[1:]
    root = Path(args[0]) if args else Path(".")
    found = capture(root)
    for i, (f, lineno, text) in enumerate(found, start=1):
        print(f"{i}. {f}:{lineno}: {text}")
    print(f"total: {len(found)}")
    if check and found:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
