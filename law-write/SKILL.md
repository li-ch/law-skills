---
name: law-write
description: Write or edit academic paper sections in LaTeX following Li's 21 writing rules for computer networking papers. Use when the user asks to write a section, edit text, improve the introduction, or draft content for their paper. After writing, invoke the humanizer skill to remove AI-generated writing artifacts.
---

# LAW Write

Write or edit LaTeX paper sections following Li's Academic Writing conventions. Every output must conform to the 21 writing rules defined in `references/writing-rules.md`.

## Before writing

Read these files to understand the paper's context:

1. `CLAUDE.md` — the paper's narrative (challenges, design decisions, key results) at the bottom
2. `AGENTS.md` — paper macros (`\sys`), venue, page limit, section structure
3. `main.tex` preamble — document class, loaded packages, defined macros
4. Existing sections in `sections/` — labels already used, cross-references to maintain

If `CLAUDE.md` has an unfilled "Paper Narrative" section, warn the user: "The paper narrative in CLAUDE.md is not filled in. I can write without it, but the content may not align with the paper's story. Fill it in for best results."

## Writing rules (summary)

Core rules (see `references/writing-rules.md` for full details with examples):

1. Active voice, present tense, first person ("We find that...")
2. Lead every paragraph with its main claim
3. Quantify every claim with specific numbers in normal weight
4. Name your discoveries with `\emph{}`
5. Never hedge — "This exposes a gap" not "This may suggest a gap"
6. Ground mechanisms in expert behavior: "Operators do X. Our system does Y."
7. One idea per sentence; no stacked subordinate clauses
8. No hyphens; use "which" or "that" instead
9. No `\textbf{}` mid-paragraph (bold numbers are OK); `\noindent\textbf{Label.}` for run-in heads
10. Code names in `\texttt{}`, system name as `\sys`
11. `\resizebox` for all tables; `algorithm`/`algpseudocode` only for algorithms
12. Leave `\textcolor{red}{##?}` for missing numbers, `\textcolor{red}{TODO:}` for unfinished work

Section discipline:

13. Know your section's scope — never preview results from later sections
14. Design sections reference problems established earlier; never re-litigate them
15. Introductions follow SCQA structure (see `references/scqa-guide.md`)

## After writing

### Step 1: Run the humanizer skill

Invoke the `humanizer` skill (blader-humanizer) to remove AI-generated writing signs from the output. This is especially important for the abstract and introduction. If the humanizer is not installed, tell the user:

```
The humanizer skill is not installed. Install it with:
  curl -sL "https://www.skillhub.club/api/v1/skills/blader-humanizer/install?agents=opencode&format=sh" | bash
```

### Step 2: Verify the abstract against the six-point checklist

Before considering a section complete, verify the abstract (in `main.tex`) against the checklist in `references/scqa-guide.md`:
1. No unexplained symbols
2. Numbers are tunable, not magic
3. Theoretical foundation is named
4. Scope is shown, not limitation
5. Zero unexplained jargon
6. No promotional language

End every response with two sections:

**Summary of changes:**
- [Bullet list of what was changed, added, or removed]

**Texts suitable for other sections:**
- [Content removed from this section that belongs elsewhere, with target section suggestions]

## When the user refers to an equation by number

When the user says "equation 1" or "equation 3", determine which equation they mean by counting sequentially from the beginning of the compiled paper:

1. Read `main.tex` to find the order of `\input{}` files
2. Search each file in order for `\begin{equation}`, `\begin{align}`, and `\[...\]` environments
3. Count equations in order of appearance
4. Tell the user which file and line the equation is in before making changes

Never assume which file an equation is in based on its label name or content. Always trace from the beginning.

- Use `\sys` (not `\sys{}`) for the system name macro
- Use `\cref{}` for all cross-references — never bare `\ref{}` unless the template requires it
- Citation style: `~\cite{key}` (tilde before cite, no space)
- `\noindent\textbf{Label.}` for run-in paragraph heads — never `\paragraph{}`
- Never modify existing LaTeX macros, document class, or class/style files
- **Never invent or fabricate citation keys.** Always verify the citation exists in `refs.bib` before using it. If you need a citation that is not in `refs.bib`, first check `nref.bib`. If the key exists there, use it (the user may have filled it in since the last build). If the key is in neither file, add a placeholder entry to `nref.bib`:
  ```
  @misc{key,
    title = {TODO: Paper Title — Venue Year},
  }
  ```
  Then use `~\cite{key}` in the text. Do not guess citation keys. Do not create entries in `refs.bib` without verifying the paper exists. The build process will detect when the user fills in `nref.bib` entries and move them to `refs.bib`.

## When editing existing text

1. Do not change the structure unless the user asks
2. Respect LaTeX syntax — never break existing macros
3. Do not change or add citations unless asked
4. Apply the 21 writing rules to improve the prose
5. Preserve all existing `\label{}` values
6. Use present tense unless discussing prior work

## Flagging missing experiments

After writing, scan the output for placeholders the agent cannot fill:

- `\textcolor{red}{##?}` — missing data
- `\textcolor{red}{TODO:}` — unfinished work
- `\includegraphics{figs/placeholder.png}` — figures that don't exist
- Any reference to measurements or experiments the agent cannot run

If found, tell the user: "This section references N items that need data or experiments. Use `law-call4expr` to create an experiment guide."
