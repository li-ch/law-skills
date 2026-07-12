---
name: law-pagecount
description: Count pages per section in a compiled LaTeX paper PDF. Enables PDF bookmarks if disabled, then extracts section titles and page numbers from the PDF outline. Used by law-build after a successful compilation.
---

# LAW Page Count

Count pages per section from a compiled paper PDF. This is invoked automatically after `law-build` succeeds.

## Workflow

### Step 1: Check for bookmarks

If the PDF has no bookmarks (outlines), enable them by running `scripts/enable-bookmarks.sh`, then trigger a rebuild before counting.

### Step 2: Count pages

Run `scripts/count-pages.sh [paper_root]` which uses pikepdf (or pdftk fallback) to extract section titles and page numbers from the PDF outline.

### Step 3: Report

Output the per-section page counts in a readable format:

```
§1 Introduction — pages 1–2 (1.5 pages)
§2 Background — pages 3–4 (1.2 pages)
```

### Step 4: Leave reminders

After counting, add a note to `todo.md`:
```
- [ ] Re-disable PDF bookmarks before submission (enabled by law-pagecount)
```

And add a note to `AGENTS.md` if not already present:
```
<!-- law-pagecount: bookmarks re-enabled for page counting. Re-disable before submission. -->
```

### Step 5: Re-disabling bookmarks

Only re-disable bookmarks when the user explicitly asks. The user must request it — never do it automatically.

## Prerequisites

- Python 3 with `pikepdf` (`pip install pikepdf`) OR `pdftk`

If neither is installed, report the missing dependency and skip the count.
