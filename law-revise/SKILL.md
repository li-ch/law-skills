---
name: law-revise
description: Implement revision items from the todo.md tracker. Use when the user asks to implement review feedback, fix items from the revision plan, or work through a checklist of paper changes. Edits LaTeX sections, rebuilds after each item, and commits with standardized messages.
---

# LAW Revise

Implement revision items from the paper's `todo.md`, rebuilding and committing after each change.

## Workflow

### Step 1: Read todo.md

Read the paper's `todo.md` to understand which items to implement and their priority.

If the item is marked ⏳ WAITING ON DATA or requires experiments (code execution, data collection, hardware access), **do not attempt to implement it.** Tell the user: "This item requires experiments the agent cannot run. Use `law-call4expr` to create an experiment guide if one doesn't already exist."

### Step 2: Implement one item at a time

For each item the user asks to implement:

1. Read the relevant `.tex` file(s) from `sections/`
2. Make the change described in the todo.md item
3. Run `law-build` to rebuild the paper
4. If build succeeds: commit with message `[R{n}] {item-code}: {description}`
5. If build fails: **stop immediately** and report the error to the user. Do NOT continue to the next item.

### Step 3: Cross-section items

If an item affects multiple sections (e.g., "R1-3: Fix convergence proof (§4.2, §7.2)"), edit ALL affected files before rebuilding and committing. Do not commit partial changes.

### Step 4: After all items

Produce a summary:
- Items completed
- Items deferred (not asked to implement)
- Any build failures encountered
- Remind user to run `law-verify` if it wasn't already run by `law-build`

## Commit message format

```
[R{n}] {item-code}: {short description}
```

Example:
```
[R1] R1-1: add coherence model subsection to §4.3
```

Agent decides commit granularity. If a change is simple (one paragraph), one commit. If a change touches multiple files and is conceptually one item, also one commit. If the changes are logically separate, separate commits.

## Safety rules

- Never implement items the user did not explicitly ask for
- Never create new citations — use `~\cite{}` with empty braces if a citation is needed
- Never modify section labels (`\label{}`) unless the item explicitly requires it
- Never change the document class or style files
- If an item says "add a figure" but the figure doesn't exist, use `figs/placeholder.png` and add `\textcolor{red}{TODO: add figure}` to the text
- After build failure: show the user the error from `temp/main.log`, do not guess at fixes
