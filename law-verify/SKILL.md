---
name: law-verify
description: Run post-build verification checks on a compiled LaTeX paper. Checks for emdashes, undefined references and citations, mid-paragraph bold text, hyphens in prose, and missing appendix cross-references. Use after law-build succeeds.
---

# LAW Verify

Run post-build checks on a compiled LaTeX paper. This is invoked automatically after `law-build` succeeds.

## Checks performed

1. **No emdashes** — `---` is not allowed in body text
2. **All `\ref{}` resolve** — no "Reference undefined" warnings in log
3. **All `\cite{}` resolve** — no "Citation undefined" warnings in log
4. **No `\textbf{}` mid-paragraph** — only `\noindent\textbf{Label.}` at paragraph start is allowed
5. **No hyphens in prose** — use "which" or "that" clauses instead
6. **Appendix breadcrumbs** — WARNING only if an appendix label has no `\cref` in main body

## How to run

```bash
bash scripts/verify.sh [paper_root_directory]
```

If no directory is given, runs in the current directory.

## When to prompt user

After running, if humanizer skill (`blader-humanizer`) is not installed, tell the user:

```
The humanizer skill is not installed. Install it with:
  curl -sL "https://www.skillhub.club/api/v1/skills/blader-humanizer/install?agents=opencode&format=sh" | bash
```

## What to do with results

- If all checks pass: report success
- If any check FAILs: list each failure with file and line number
- If any check WARNs: list warnings but do not block
- Do not attempt to fix issues — the user will fix them
