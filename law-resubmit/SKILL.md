---
name: law-resubmit
description: Prepare a paper for resubmission to a different venue after rejection. Use when the user asks to resubmit, switch venues, or change the target conference. Copies the paper repo, swaps document templates, archives old artifacts, and preserves git history.
---

# LAW Resubmit

Prepare a paper for resubmission to a new venue. Copies the repo, swaps templates, archives old artifacts, and continues git history.

## Workflow

### Step 1: Gather parameters

Ask the user for:
- New venue (`nsdi`, `sigcomm`, `apnet`, `arxiv`)
- New year
- New cycle (optional)

Same interactive prompt flow as `law-bootstrap`.

### Step 2: Run resubmit script

```bash
bash scripts/resubmit.sh --venue <venue> --year <year> [--cycle <cycle>]
```

The script:
1. Copies the entire paper repo to `{name}-{new-venue}-{new-year}[-{new-cycle}]`
2. Swaps document class, style files, and citation style for the new venue
3. Updates `AGENTS.md` with the new venue name
4. Strips venue-specific formatting (e.g., ACM copyright block → remove for arxiv submission)
5. Moves old timestamped PDFs (`main-*.pdf`) to `archive/`
6. Moves old `reviews/` contents to `archive/`
7. Commits: `git add -A && git commit -m "resubmit: switch venue to {new-venue} {new-year}"`

### Step 3: Safety checks

- If the target directory already exists: warn and ask for confirmation
- If the new venue is the same as the old venue: warn (should use a different cycle/year)
- Never delete the original paper repo — only copy and modify the copy

## What gets archived

Only `main-*.pdf` files and `reviews/` contents go to `archive/`. Everything else is overwritten in-place in the new repo.

## What stays the same

- All section content (`sections/*.tex`)
- All figures (`figs/*`)
- All data (`data/*`)
- Paper narrative in `CLAUDE.md`
- Git history continues (no fresh `git init`)
