---
name: law-upstream
description: Merge local paper changes back to the shared ~/.common-law/ global state. Use when the user asks to upstream changes, sync bib entries, or merge writing guide modifications. Presents a list of local modifications and lets the user select what to merge.
---

# LAW Upstream

Merge local paper modifications back to `~/.common-law/`. This keeps the global bib file, writing guide, and build scripts in sync across all papers.

## What gets tracked

Three categories of local changes:

1. **New bib entries** — citations added to the paper's `refs.bib` that don't exist in `~/.common-law/bib/refs.bib`
2. **CLAUDE.md changes** — modifications to the writing guide (excluding the "Paper Narrative" section)
3. **Script changes** — modifications to `build.sh`, `build.bat`, or `verify.sh`

## Workflow

### Step 1: Scan for changes

Run `scripts/upstream-bib.sh` to find new bib entries and `scripts/upstream-claude.sh` to find CLAUDE.md changes.

For script changes, diff the paper's scripts against the skill's canonical copies.

### Step 2: Present options to user

Show a grouped list:

```
Changes ready to upstream:

[Bib entries — 3 new]
  1. extraref1 — "Machine Learning for Resource Management..." (Garcia, EuroSys 2025)
  2. extraref2 — "Reinforcement Learning for Cluster Scheduling" (Nguyen, MLSys 2024)
  3. extraref3 — "A Formal Analysis of Joint..." (Tanaka, PER 2025)

[CLAUDE.md changes]
  4. Added "No hyphens" rule to Hard Prohibitions section

[Script changes]
  (none)

Select items to upstream (e.g., "1,2,4" or "all"):
```

### Step 3: Merge selected changes

- **Bib entries:** append to `~/.common-law/bib/refs.bib`, deduplicate by citation key
- **CLAUDE.md:** strip the "Paper Narrative" section and everything below it, then merge changes into `~/.common-law/paper-style/CLAUDE.md`
- **Scripts:** copy to the corresponding skill's `scripts/` directory

### Step 4: Report

Tell the user exactly what was merged and where.

## Prompted by other skills

After `law-write` or `law-revise` sessions that add citations, ask: "You added N new citations. Upstream them to the global bib?"

The user can say yes, no, or "later." Do not push.

## Scripts

- `scripts/upstream-bib.sh` — finds new bib entries and handles deduplication
- `scripts/upstream-claude.sh` — diffs CLAUDE.md and strips the narrative section
