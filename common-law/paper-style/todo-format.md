# Standard todo.md Format

Every paper's revision tracker follows this structure. When parsing reviews or implementing revisions, use this as the canonical format.

## Template

```markdown
# TODO: [paper-short-name] — [venue] [track]

## Current Status (YYYY-MM-DD)

**Paper:** X pages (Y body + Z refs). Latest build: `main-YYYYMMDDHHMM.pdf`.
Review-N revision in progress. Review-(N-1) complete (all items).
Title: *Paper Title.*

**Completeness policy:** [any paper-specific policy about page limits, appendix, etc.]

## P0 — Review-N: [one-line summary of review verdict and core critique]

[2-3 sentence context paragraph explaining what this review round requires]

Execution order: [dependencies between phases]

### Phase 1 — [phase name] (parallel/sequential)

- [ ] **Item code. Short description** (effort estimate)
      Detailed description of what to do. Which section. What to change. Expected output.
      Output: `path/to/file` if applicable.

### Phase 2 — [phase name]

- [ ] **Item code. Description** ...

### Final checks (pre-submission)

- [ ] No emdashes in main.tex or captions
- [ ] Every line-starting `\textbf{...}` preceded by `\noindent`
- [ ] All `\ref{}` and `\cref{}` resolve (bibtex: zero undefined citations)
- [ ] `build.sh` / `build.bat` runs clean
- [ ] Main-body page count reported and within limit
- [ ] All review items addressed in text (not deferred)

## Completed — revision history

### Review-N revision cycle (complete)
- [x] Item code. Description

### Review-(N-1) revision cycle (complete)
- [x] Item code. Description
```

## Priority levels

| Level | Meaning | When to use |
|---|---|---|
| **P0** | Acceptance-critical | Must fix or paper will be rejected. Reviewer explicitly states this is required. |
| **P1** | Major concern | Strongly impacts reviewer score. Addressing it significantly improves paper. |
| **P2** | Minor / polish | Nice to have. Typos, grammar, minor clarifications, formatting. |

## Item code format

- Review round prefix: `R1`, `R2`, `R3`, etc.
- Sequential number within round: `R1-1`, `R1-2`, `R2-1`, etc.
- Cross-section items tag all affected sections: `R1-1: Fix convergence proof (§4.2, §7, Table 3)`
- Uncertain items (agent isn't sure): `⚠️ UNCERTAIN: R1-5: Add discussion of failure modes?`

## Example (from DONA paper)

```markdown
## P0 — Review-3: acceptance requirements (completed 2026-04-18)

The reviewer gave five explicit requirements for acceptance. Each is design or framing work, not experimental.

### 1. Name-to-address bootstrap + fair first-access comparison

- [x] **R3-1. New §3.1 subsection "Name-to-address binding."**
- [x] **R3-2. New `fig-first-access.py` + `fig-first-access.png`** (grouped bar chart, three regimes × four configs, 170× annotation).
- [x] **R3-3. New data** `expr/data/rdma-bench/first_access_regimes-0418.csv`.
- [x] **R3-4. Rewrote §2.2** with three-regime narrative.

### 2. Bandwidth tax as a first-order cost

- [x] **R3-5. §1 P3 sentence** — bandwidth caveat moved to §3.4.
- [x] **R3-6. §5.5 mixed-traffic arithmetic fix** — "figure assumes client-owned slab".
```
