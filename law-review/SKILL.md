---
name: law-review
description: Parse reviewer feedback into a structured todo.md revision tracker for academic papers. Use when the user asks to triage reviews, extract actionable items from review comments, or create a revision plan from reviewer feedback. Flags uncertain items for human confirmation.
---

# LAW Review

Parse reviewer feedback into a structured `todo.md` using the standard format defined in `~/.common-law/paper-style/todo-format.md`.

## Workflow

### Step 1: Read the reviews

Read all review files from the paper's `reviews/` directory. Reviews are plain text or markdown files containing reviewer comments, scores, and recommendations.

### Step 2: Extract actionable items

For each review, identify every concrete action the reviewer is asking for. Skip vague praise, skip generic complaints without specific asks. An item is "actionable" if you can answer "what file do I edit and what do I change?"

### Step 3: Assign priority

| Level | Criteria |
|---|---|
| **P0** | Reviewer explicitly states this is required for acceptance. The paper will be rejected without it. |
| **P1** | Major concern that strongly impacts the reviewer's score. Addressing it significantly strengthens the paper. |
| **P2** | Minor issues: typos, grammar, formatting, figure readability, missing citations, clarifications. |

If unsure about priority, flag it and default to P1.

### Step 4: Group by review round

Use the round prefix `R1`, `R2`, `R3`, etc. If this is the first review, use `R1`. If reviews span multiple rounds (revision and re-review), create separate sections per round.

### Step 5: Write todo.md

Write the output to `todo.md`. Reference `~/.common-law/paper-style/todo-format.md` for the exact format.

Item code format:
- `R{n}-{number}` — sequential within round
- Cross-section items: append affected sections as `(§X.Y, §Z)`
- Uncertain items: prefix with `⚠️ UNCERTAIN:`

Example:
```
- [ ] R1-1. Add coherence model subsection to §4.3 (0.3 day)
- [ ] ⚠️ UNCERTAIN: R1-5. The reviewer mentions "failure modes" — is this a new subsection or a paragraph?
```

### Step 6: Report to user

After writing `todo.md`, tell the user:
1. How many items were extracted (by priority)
2. Which items are flagged as UNCERTAIN
3. "Please review and adjust priorities before I implement anything."

### Step 7: Offer to create an experiment guide

After writing `todo.md`, count items that require experiments (new measurements, stress tests, code execution, hardware access, figure generation). The agent cannot complete these. If any such items exist:

1. Mark them ⏳ WAITING ON DATA in `todo.md` with "See Experiment N in expr.todo.md"
2. Tell the user: "N items require experiments. Use `law-call4expr` to create an experiment guide."
3. If the user says yes, invoke `law-call4expr` to produce the guide

How to identify experiment items: the reviewer asks for "add experiments," "measure X," "test under Y," "report distributions," "run on real traces," "add stress tests," or any action that requires running code or collecting data that the agent cannot directly perform.

## Rules

- Never skip an actionable item. If a reviewer says "fix this," it goes in the list.
- If a reviewer says "consider X" without being explicit, flag it as UNCERTAIN.
- Group similar items from different reviewers under one item with a note: "(R1, R2 both mention this)"
- Do not implement anything. This skill only writes the todo.md.
