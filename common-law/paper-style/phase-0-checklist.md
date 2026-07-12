# Phase 0 — Shared Infrastructure Test Checklist

Run each test before proceeding to skill implementation.

## P0-1: Directory structure

- [ ] `~/.common-law/` exists
- [ ] `~/.common-law/paper-style/` exists
- [ ] `~/.common-law/bib/` exists
- [ ] `~/.common-law/test-fixtures/` exists
- [ ] `~/.common-law/test-fixtures/sample-paper/` exists
- [ ] `~/.common-law/test-fixtures/bad-paper/` exists
- [ ] `~/.common-law/test-fixtures/sample-reviews/` exists
- [ ] `~/.common-law/test-fixtures/sample-pdfs/` exists

## P0-2: CLAUDE.md

- [ ] `~/.common-law/paper-style/CLAUDE.md` exists and is non-empty
- [ ] Contains "Persona and Context" section
- [ ] Contains "Hard Prohibitions" section with banned words and patterns
- [ ] Contains 6 writing samples (bad → improved)
- [ ] Contains "Paper Narrative" section at the end
- [ ] No agent-framework-specific references (no "openode", "claude-code", etc.)

## P0-3: writing-rules.md

- [ ] `~/.common-law/paper-style/writing-rules.md` exists
- [ ] Contains exactly 21 numbered rules (check: `grep -c "^### [0-9]"`)
- [ ] Each rule has a "Good" example or clear specification
- [ ] Contains annotated writing samples section (Samples 1–6 with rule references)

## P0-4: venue-map.md

- [ ] `~/.common-law/paper-style/venue-map.md` exists
- [ ] Contains rows for nsdi, sigcomm, apnet, arxiv
- [ ] Each row has: venue, document class, style file, bib style, page limit, anon mode
- [ ] Contains instructions for adding a new venue

## P0-5: todo-format.md

- [ ] `~/.common-law/paper-style/todo-format.md` exists
- [ ] Contains template with P0/P1/P2 grouping
- [ ] Contains priority level definitions
- [ ] Contains item code format specification
- [ ] Contains example from DONA paper

## P0-6: refs.bib

- [ ] `~/.common-law/bib/refs.bib` exists and is non-empty
- [ ] Contains at least 100 bib entries (check: `grep -c "^@"`)
- [ ] No immediate syntax errors (check: balanced braces)

## P0-7: Test fixtures

- [ ] `sample-paper/main.tex` exists with `\documentclass` and `\input{sections/*.tex}`
- [ ] `sample-paper/sections/1.intro.tex` exists with `\section{Introduction}`
- [ ] `sample-paper/sections/2.bg.tex` exists with `\section{Background}`
- [ ] `sample-paper/sections/4.design.tex` exists with `\section{Design}`
- [ ] `sample-paper/refs.bib` contains exactly 5 entries
- [ ] `bad-paper/sections/3.design.tex` contains at least 3 emdashes (`---`)
- [ ] `bad-paper/sections/3.design.tex` contains hyphens in prose
- [ ] `bad-paper/sections/3.design.tex` contains `\textbf{}` mid-paragraph
- [ ] `bad-paper/sections/3.design.tex` contains undefined `\ref{}`
- [ ] `sample-reviews/reviews-r1.txt` contains 3 reviews
- [ ] `sample-reviews/reviews-r2.txt` contains 2 reviews
- [ ] `sample-bib-entries.bib` contains 5 unique entries not in `refs.bib`
