---
name: law-build
description: Compile a LaTeX academic paper with pdflatex. Use when the user asks to build, compile, or check the paper. Also run law-pagecount and law-verify after a successful build.
---

# LAW Build

Compile a LaTeX paper using pdflatex, producing a timestamped PDF `main-YYYYMMDDHHMM.pdf`. The build script opens this file automatically after compilation.

## Workflow

### Step 1: Detect platform and run build script

- macOS/Linux: `bash scripts/build.sh`
- Windows: `build.bat`

The script detects whether bibtex is needed by checking for `\bibliography{` in `main.tex`.

### Step 2: After build succeeds

Tell the user the build succeeded and show the output filename. Then:

1. Run `law-pagecount` — counts pages per section from the compiled PDF
2. Run `law-verify` — runs post-build checks (emdashes, refs, cites, formatting)
3. Commit to git with a meaningful message

If either skill is not installed, tell the user the install command.

### Step 3: Commit after build

After every successful build, commit all changes to git. This creates a recoverable snapshot of the paper state at each build.

To generate a meaningful commit message, run `git diff --staged` (or `git diff` if nothing staged) and `git status --short` to see what changed. Summarize the changes in one line. Examples:

- "write §1 introduction with SCQA structure"
- "add §3 system overview and architecture diagram"
- "fix: replace bold numbers with normal text per writing rules"
- "build: add real citations for related work"
- "shrink §4 from 2.5 to 1.8 pages to fit page limit"

If nothing changed (rebuild with no edits), do not create an empty commit. Only commit when there are actual changes.

Use `git add -A` to stage everything, then `git commit -m "message"`.

### Step 4: Check `nref.bib` for unresolved citations

The paper uses two bib files:
- `refs.bib` — verified citations with complete entries
- `nref.bib` — placeholder entries for citations that need the user to fill in

After every build, check `nref.bib`:

1. Count entries with `TODO` in the `title` field (unresolved)
2. Count entries without `TODO` in the `title` field (user has filled them in)
3. For newly filled entries: move them from `nref.bib` to `refs.bib` by:
   - Appending the complete entry to the end of `refs.bib`
   - Removing it from `nref.bib`
4. Report to the user:
   - "nref.bib: N entries moved to refs.bib, M entries still need attention"
   - If any unresolved entries remain, list them with their TODO descriptions

An entry is "filled" when its `title` field no longer starts with `{TODO:`. An entry is "unresolved" when its `title` field starts with `{TODO:`.

If `nref.bib` does not exist in the paper repo, skip this step.

### Step 5: If build fails

Display the last 20 lines of `temp/main.log` to the user. Do NOT try to fix LaTeX errors automatically. Do NOT retry the build. The user will fix the issue and ask to build again.

## Prerequisites

- `pdflatex` must be installed. If not found, print: "Install MacTeX from https://tug.org/mactex/ (macOS) or TeX Live from https://tug.org/texlive/ (Windows/Linux)."
- `bibtex` (comes with TeX distribution)

## Important

- Always rebuild the full paper. Do not skip passes or optimize.
- The build output goes to `temp/`.
- The build produces `main-YYYYMMDDHHMM.pdf` in the paper root and opens exactly that one file.
- All `main-*.pdf` are in `.gitignore` — they are build artifacts, not source.
- **Never compose your own build command.** Always use `bash build.sh` (macOS/Linux) or `build.bat` (Windows). Do not run `pdflatex` directly. Do not use `open main-*.pdf` or any wildcard — the build script handles opening the correct file.
